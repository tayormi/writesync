import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:build/build.dart' hide Builder;
import 'package:build/build.dart' as build show Builder;
import 'package:path/path.dart' as path;
import '../services/cache_service.dart';
import '../services/content_processor.dart';
import '../services/asset_service.dart';

build.Builder blogPostBuilder(BuilderOptions options) => BlogPostBuilder();

class BlogPostBuilder implements build.Builder {
  final _cache = CacheService.instance;
  final _contentProcessor = ContentProcessor.instance;
  final _assetService = AssetService.instance;

  @override
  Map<String, List<String>> get buildExtensions => {
        '.md': ['.blog.dart'],
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;

    // Read the input file content
    final content = await buildStep.readAsString(inputId);
    final contentBytes = Uint8List.fromList(utf8.encode(content));
    final inputStream = Stream.value(contentBytes);

    // Process markdown content
    final result = await _contentProcessor.processMarkdownStream(inputStream);

    // Check if content has changed using cache
    if (!_cache.hasContentChanged(inputId.path, result.content)) {
      log.fine('Content unchanged for ${inputId.path}, skipping build');
      return;
    }

    // Generate class name from slug or filename
    final slug = (result.metadata['slug'] as String?) ??
        path
            .basenameWithoutExtension(inputId.path)
            .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')
            .toLowerCase();

    final className = slug
        .split(RegExp(r'[_-]'))
        .map((part) =>
            part.isEmpty ? '' : part[0].toUpperCase() + part.substring(1))
        .join('');

    // Process HTML content in chunks
    final htmlStream = _contentProcessor.processHtmlStream(result.content);
    final optimizedHtmlStream =
        _contentProcessor.optimizeHtmlStream(htmlStream);

    final htmlParts = <String>[];
    await for (final chunk in optimizedHtmlStream) {
      htmlParts.add(chunk);
    }
    final htmlContent = htmlParts.join('\n');

    // Process any embedded assets
    final assetUrls = _extractAssetUrls(htmlContent);
    for (final url in assetUrls) {
      if (url.startsWith('assets/')) {
        final assetId = AssetId(buildStep.inputId.package, url);
        if (await buildStep.canRead(assetId)) {
          final assetContent = await buildStep.readAsBytes(assetId);
          await _assetService.processAsset(url, assetContent);
        }
      }
    }

    // Convert metadata to a Map<String, dynamic>
    final metadata = Map<String, dynamic>.from(result.metadata);

    final output = '''
// Generated code - do not modify by hand
// ignore_for_file: undefined_identifier, expected_identifier, invalid_reference_to_this, non_constant_identifier_names, constant_identifier_names, invalid_element_content

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_blog/models/blog_post.dart';
import 'package:jaspr_blog/posts/blog_post_registry.dart';

class BlogPost$className extends Component implements BlogPost {
  const BlogPost$className();
  
  @override
  Element createElement() => createElement();
  
  @override
  String get title => '${metadata['title']}';
  
  @override
  String get slug => '$slug';
  
  @override
  DateTime get publishedAt => DateTime.parse('${metadata['date']}');
  
  @override
  List<String> get tags => ${metadata['tags'] != null ? "['${(metadata['tags'] as List).join("', '")}']" : '[]'};
  
  @override
  String get description => '${metadata['description'] ?? ''}';
  
  @override
  String get author => '${metadata['author'] ?? ''}';
  
  @override
  String? get imageUrl => ${metadata['image'] != null ? "'${metadata['image']}'" : 'null'};
  
  @override
  String? get authorImageUrl => ${metadata['authorImage'] != null ? "'${metadata['authorImage']}'" : 'null'};
  
  @override
  Map<String, String> get metadata => {
    ${metadata.entries.where((e) => ![
              'title',
              'slug',
              'date',
              'tags',
              'description',
              'author',
              'image',
              'authorImage'
            ].contains(e.key)).map((e) => "'${e.key}': '${e.value}'").join(',\n    ')}
  };
  
  static final String _rawMarkdown = r"""${result.content}""";
  
  @override
  String get markdownContent => _rawMarkdown;
  
  @override
  String get content => r"""$htmlContent""";
  
  @override
  Component render(BuildContext context) {
    return div(
      id: slug,
      classes: 'blog-post',
      [
        div(
          classes: 'prose prose-lg mx-auto prose-img:rounded-xl prose-headings:font-semibold',
          attributes: {
            'innerHTML': content,
          },
          [],
        ),
      ],
    );
  }
  
  @override
  String get canonicalUrl => '/blog/$slug';
  
  @override
  String get metaDescription => description.isEmpty
      ? markdownContent.substring(
          0, markdownContent.length > 160 ? 160 : markdownContent.length)
      : description;
  
  @override
  Key? get key => null;
}

// Register this blog post with the registry
void registerBlogPost() {
  registerPostFactory(() => const BlogPost$className());
}
''';

    final outputId = inputId.changeExtension('.blog.dart');
    await buildStep.writeAsString(outputId, output);
  }

  Set<String> _extractAssetUrls(String html) {
    final urls = <String>{};

    // Extract image sources
    final imgRegex = RegExp(r'<img[^>]+src="([^"]+)"');
    for (final match in imgRegex.allMatches(html)) {
      final url = match.group(1);
      if (url != null) urls.add(url);
    }

    // Extract other asset references (e.g., from style attributes)
    final styleRegex = RegExp(r"""url\(['"]?([^'"\)]+)['"]?\)""");
    for (final match in styleRegex.allMatches(html)) {
      final url = match.group(1);
      if (url != null) urls.add(url);
    }

    return urls;
  }
}
