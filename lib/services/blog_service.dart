import 'dart:convert';
import 'dart:html';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../models/blog_post.dart';
import 'package:yaml/yaml.dart';

// Create an AsyncNotifier to handle the blog service state
class BlogServiceNotifier extends AsyncNotifier<BlogService> {
  @override
  Future<BlogService> build() async {
    final service = BlogService();
    await service.initialize();
    return service;
  }
}

// Update the provider to use AsyncNotifier
final blogServiceProvider =
    AsyncNotifierProvider<BlogServiceNotifier, BlogService>(() {
  return BlogServiceNotifier();
});

class BlogService {
  final List<BlogPost> _posts = [];

  BlogService();

  Future<void> initialize() async {
    try {
      final manifestResponse =
          await HttpRequest.getString('assets/posts/manifest.json');
      final List<String> files =
          (jsonDecode(manifestResponse) as List).cast<String>();

      for (final file in files) {
        try {
          final content = await HttpRequest.getString('assets/posts/$file');
          final post = _parseMarkdown(content);
          _posts.add(post);
          print('Loaded post: ${post.title}');
        } catch (e) {
          print('Error loading post $file: $e');
        }
      }
    } catch (e) {
      print('Error loading manifest: $e');
      // Create a demo post as fallback
      const demoMarkdown = '''
      # Welcome to my blog
      This is a demo post.
      ''';

      final post = _parseMarkdown(demoMarkdown);
      _posts.add(post);
      print('Created demo post as fallback');
    }
  }

  List<BlogPost> getAllPosts() {
    final posts = List<BlogPost>.from(_posts);
    posts.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    print('Returning ${posts.length} posts');
    return posts;
  }

  BlogPost? getPostBySlug(String slug) {
    try {
      return _posts.firstWhere((post) => post.slug == slug);
    } on StateError {
      return null;
    }
  }

  List<BlogPost> searchPosts(String? query) {
    if (query == null || query.isEmpty) {
      return getAllPosts();
    }

    final normalizedQuery = query.toLowerCase();
    final filteredPosts = _posts.where((post) {
      return post.title.toLowerCase().contains(normalizedQuery) ||
          post.description.toLowerCase().contains(normalizedQuery) ||
          post.tags.any((tag) => tag.toLowerCase().contains(normalizedQuery));
    }).toList();

    filteredPosts.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    return filteredPosts;
  }

  BlogPost _parseMarkdown(String content) {
    print('Parsing markdown content:');
    print(content);

    final parts = content.split('---');
    if (parts.length < 3) {
      throw FormatException('Invalid markdown format: missing frontmatter');
    }

    final yamlContent = parts[1].trim();
    print('YAML content:');
    print(yamlContent);

    // Join all parts after the frontmatter and trim whitespace
    final markdownContent = parts.sublist(2).join('---').trim();
    print('Markdown content after parsing:');
    print(markdownContent);

    final frontMatter = loadYaml(yamlContent) as Map;
    print('Parsed frontmatter:');
    print(frontMatter);

    return BlogPost.fromMarkdown(
      markdownContent,
      Map<String, dynamic>.from(frontMatter),
    );
  }

  List<BlogPost> get posts => List.unmodifiable(_posts);
}
