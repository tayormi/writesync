// Generated code - do not modify by hand
// ignore_for_file: undefined_identifier, expected_identifier, invalid_reference_to_this, non_constant_identifier_names, constant_identifier_names, invalid_element_content

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_blog/models/blog_post.dart';
import 'package:jaspr_blog/posts/blog_post_registry.dart';

class BlogPostFlutterWebJaspr extends Component implements BlogPost {
  const BlogPostFlutterWebJaspr();
  
  @override
  Element createElement() => createElement();
  
  @override
  String get title => 'Flutter Web vs Jaspr - Choosing the Right Dart Web Framework';
  
  @override
  String get slug => 'flutter-web-jaspr';
  
  @override
  DateTime get publishedAt => DateTime.parse('2024-02-01');
  
  @override
  List<String> get tags => ['flutter', 'jaspr', 'web-development', 'dart'];
  
  @override
  String get description => 'A detailed comparison between Flutter Web and Jaspr for building web applications with Dart. Learn the pros and cons of each framework and when to use them.';
  
  @override
  String get author => 'Michael Zhang';
  
  @override
  String? get imageUrl => 'https://images.unsplash.com/photo-1517292987719-0369a794ec0f';
  
  @override
  String? get authorImageUrl => null;
  
  @override
  Map<String, String> get metadata => {
    'author_image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
    'metadata': '{readTime: 10 min}'
  };
  
  static final String _rawMarkdown = r"""# Flutter Web vs Jaspr: Choosing the Right Dart Web Framework

When it comes to building web applications with Dart, developers have two powerful options: Flutter Web and Jaspr. Let's explore both frameworks to help you make an informed decision.

## Flutter Web Overview

Flutter Web allows you to build web applications using the same codebase as your mobile apps. Here are some key features:

- Single codebase for mobile, desktop, and web
- Rich widget ecosystem
- Powerful animations and custom painting
- Hot reload for rapid development

```dart
class MyWebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello, Flutter Web!'),
        ),
      ),
    );
  }
}
```

## Jaspr: The New Kid on the Block

Jaspr is specifically designed for web development, offering:

- Smaller bundle sizes
- Better SEO capabilities
- Server-side rendering
- Native web components

```dart
class MyJasprApp extends StatelessComponent {
  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div(classes: 'container', [
      text('Hello, Jaspr!'),
    ]);
  }
}
```

## Performance Comparison

### Bundle Size
- Flutter Web: ~1MB (gzipped)
- Jaspr: ~100KB (gzipped)

### First Paint
- Flutter Web: 1-2 seconds
- Jaspr: Under 500ms

## When to Choose Each Framework

### Choose Flutter Web When:
- You need cross-platform compatibility
- You want rich animations and complex UI
- You're building a web app that feels like a native app
- You have an existing Flutter codebase

### Choose Jaspr When:
- SEO is crucial for your application
- You need smaller bundle sizes
- You want better integration with web standards
- Server-side rendering is a requirement

## Best Practices

1. Consider your target audience and their devices
2. Evaluate your performance requirements
3. Think about SEO needs
4. Consider your team's expertise
5. Plan for long-term maintenance

## Conclusion

Both frameworks have their strengths. Flutter Web excels in cross-platform development and rich UIs, while Jaspr shines in web-specific scenarios requiring optimal performance and SEO. Choose based on your project's specific needs and constraints.""";
  
  @override
  String get markdownContent => _rawMarkdown;
  
  @override
  String get content => r"""<h1>Flutter Web vs Jaspr: Choosing the Right Dart Web Framework</h1>
<p>
When it comes to building web applications with Dart, developers have two powerful options: Flutter Web and Jaspr. Let\'s explore both frameworks to help you make an informed decision.</p>
<h2>Flutter Web Overview</h2>
<p>
Flutter Web allows you to build web applications using the same codebase as your mobile apps. Here are some key features:</p>
<p>- Single codebase for mobile, desktop, and web</p>
<p>- Rich widget ecosystem</p>
<p>- Powerful animations and custom painting</p>
<p>- Hot reload for rapid development</p>
<pre><code class="language-dart">class MyWebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(\'Hello, Flutter Web!\'),
        ),
      ),
    );
  }
}
</code></pre>
<h2>Jaspr: The New Kid on the Block</h2>
<p>
Jaspr is specifically designed for web development, offering:</p>
<p>- Smaller bundle sizes</p>
<p>- Better SEO capabilities</p>
<p>- Server-side rendering</p>
<p>- Native web components</p>
<pre><code class="language-dart">class MyJasprApp extends StatelessComponent {
  @override
  Iterable&lt;Component&gt; build(BuildContext context) sync* {
    yield div(classes: \'container\', [
      text(\'Hello, Jaspr!\'),
    ]);
  }
}
</code></pre>
<h2>Performance Comparison</h2>
<h3>Bundle Size</h3>
<p>- Flutter Web: ~1MB (gzipped)</p>
<p>- Jaspr: ~100KB (gzipped)</p>
<h3>First Paint</h3>
<p>- Flutter Web: 1-2 seconds</p>
<p>- Jaspr: Under 500ms</p>
<h2>When to Choose Each Framework</h2>
<h3>Choose Flutter Web When:</h3>
<p>- You need cross-platform compatibility</p>
<p>- You want rich animations and complex UI</p>
<p>- You\'re building a web app that feels like a native app</p>
<p>- You have an existing Flutter codebase</p>
<h3>Choose Jaspr When:</h3>
<p>- SEO is crucial for your application</p>
<p>- You need smaller bundle sizes</p>
<p>- You want better integration with web standards</p>
<p>- Server-side rendering is a requirement</p>
<h2>Best Practices</h2>
<p>1. Consider your target audience and their devices
2. Evaluate your performance requirements
3. Think about SEO needs
4. Consider your team\'s expertise
5. Plan for long-term maintenance</p>
<h2>Conclusion</h2>
<p>
Both frameworks have their strengths. Flutter Web excels in cross-platform development and rich UIs, while Jaspr shines in web-specific scenarios requiring optimal performance and SEO. Choose based on your project\'s specific needs and constraints.</p>""";
  
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
  String get canonicalUrl => '/blog/flutter-web-jaspr';
  
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
  registerPostFactory(() => const BlogPostFlutterWebJaspr());
}
