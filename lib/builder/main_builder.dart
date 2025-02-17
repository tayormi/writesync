import 'dart:async';
import 'package:build/build.dart' hide Builder;
import 'package:build/build.dart' as build show Builder;
import 'package:glob/glob.dart';
import 'package:path/path.dart' as path;

build.Builder mainBuilder(BuilderOptions options) => MainBuilder();

class MainBuilder implements build.Builder {
  @override
  Map<String, List<String>> get buildExtensions => {
        '.dart': ['.g.dart'],
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    // Find all blog post files
    final blogPosts = await buildStep
        .findAssets(Glob('lib/posts/**.blog.dart'))
        .map((asset) => path.basenameWithoutExtension(asset.path))
        .where((filename) => filename.endsWith('.blog'))
        .map((filename) => filename.substring(0, filename.length - 5))
        .toList();

    // Sort blog posts to ensure consistent order
    blogPosts.sort();

    final output = '''
// Generated code - do not modify by hand

import 'package:jaspr/browser.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:writesync/app.dart';
import 'package:writesync/services/blog_service.dart';
import 'package:writesync/posts/blog_post_registry.dart';

// Import all blog posts
${blogPosts.asMap().entries.map((e) => "import 'package:writesync/posts/${e.value}.blog.dart' deferred as post${e.key + 1};").join('\n')}

void main() async {
  // Load and register all blog posts
  await Future.wait([
    ${blogPosts.asMap().entries.map((e) => "post${e.key + 1}.loadLibrary().then((_) => post${e.key + 1}.registerBlogPost()),").join('\n    ')}
  ]);

  // Register all posts with the blog service
  registerAllPosts();

  // Initialize the blog service
  await BlogService.instance.initialize();

  // Run the app
  runApp(
    ProviderScope(
      child: App(),
    ),
  );
}
''';

    final outputId = AssetId(
      buildStep.inputId.package,
      'web/main.g.dart',
    );
    await buildStep.writeAsString(outputId, output);
  }
}
