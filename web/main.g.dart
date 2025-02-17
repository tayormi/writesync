// Generated code - do not modify by hand

import 'package:jaspr/browser.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:writesync/app.dart';
import 'package:writesync/services/blog_service.dart';
import 'package:writesync/posts/blog_post_registry.dart';

// Import all blog posts
import 'package:writesync/posts/advanced_dart_patterns.blog.dart' deferred as post1;
import 'package:writesync/posts/ai_in_dart.blog.dart' deferred as post2;
import 'package:writesync/posts/dart_async_programming.blog.dart' deferred as post3;
import 'package:writesync/posts/dart_web_development.blog.dart' deferred as post4;
import 'package:writesync/posts/flutter_web_jaspr.blog.dart' deferred as post5;
import 'package:writesync/posts/markdown_showcase.blog.dart' deferred as post6;
import 'package:writesync/posts/performance_optimization.blog.dart' deferred as post7;
import 'package:writesync/posts/readme_guide.blog.dart' deferred as post8;
import 'package:writesync/posts/responsive_design_jaspr.blog.dart' deferred as post9;
import 'package:writesync/posts/state_management_jaspr.blog.dart' deferred as post10;
import 'package:writesync/posts/tailwind_tips.blog.dart' deferred as post11;
import 'package:writesync/posts/web_accessibility.blog.dart' deferred as post12;
import 'package:writesync/posts/welcome.blog.dart' deferred as post13;

void main() async {
  // Load and register all blog posts
  await Future.wait([
    post1.loadLibrary().then((_) => post1.registerBlogPost()),
    post2.loadLibrary().then((_) => post2.registerBlogPost()),
    post3.loadLibrary().then((_) => post3.registerBlogPost()),
    post4.loadLibrary().then((_) => post4.registerBlogPost()),
    post5.loadLibrary().then((_) => post5.registerBlogPost()),
    post6.loadLibrary().then((_) => post6.registerBlogPost()),
    post7.loadLibrary().then((_) => post7.registerBlogPost()),
    post8.loadLibrary().then((_) => post8.registerBlogPost()),
    post9.loadLibrary().then((_) => post9.registerBlogPost()),
    post10.loadLibrary().then((_) => post10.registerBlogPost()),
    post11.loadLibrary().then((_) => post11.registerBlogPost()),
    post12.loadLibrary().then((_) => post12.registerBlogPost()),
    post13.loadLibrary().then((_) => post13.registerBlogPost()),
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
