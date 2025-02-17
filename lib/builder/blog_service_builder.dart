import 'dart:async';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;

Builder blogServiceBuilder(BuilderOptions options) => BlogServiceBuilder();

class BlogServiceBuilder implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => {
        r'$lib$': ['services/blog_service.g.dart']
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    // Find all generated blog post components
    final posts = <Map<String, String>>[];
    await for (final id
        in buildStep.findAssets(Glob('lib/posts/*.blog.dart'))) {
      final filename =
          p.basenameWithoutExtension(id.path).replaceAll('.blog', '');
      final className = filename
          .split('_')
          .map((part) => part[0].toUpperCase() + part.substring(1))
          .join('');
      posts.add({
        'filename': filename,
        'className': 'BlogPost$className',
      });
    }

    // Generate the blog service helper
    final output = '''
// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:writesync/services/blog_service.dart';
${posts.map((post) => "import 'package:writesync/posts/${post['filename']}.blog.dart';").join('\n')}

extension BlogServiceInitialization on BlogService {
  Future<void> _initializeBlogPosts() async {
    ${posts.map((post) => "${post['className']}().register();").join('\n    ')}
  }
}
''';

    // Write the output file
    final outputId = AssetId(
      buildStep.inputId.package,
      p.join('lib', 'services', 'blog_service.g.dart'),
    );
    await buildStep.writeAsString(outputId, output);
  }
}
