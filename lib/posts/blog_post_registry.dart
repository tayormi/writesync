import 'package:jaspr/jaspr.dart';
import '../services/blog_service.dart';
import '../models/blog_post.dart';

// This list will be populated by the build_runner
final List<BlogPost Function()> _postFactories = [];

/// Registers a blog post factory function
void registerPostFactory(BlogPost Function() factory) {
  _postFactories.add(factory);
}

/// Registers all blog posts with the BlogService
void registerAllPosts() {
  print('Registering all blog posts...');
  for (final factory in _postFactories) {
    final post = factory();
    BlogService.instance.registerPost(post);
  }
  print('Finished registering blog posts.');
}
