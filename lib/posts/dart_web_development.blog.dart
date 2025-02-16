// Generated code - do not modify by hand
// ignore_for_file: undefined_identifier, expected_identifier, invalid_reference_to_this, non_constant_identifier_names, constant_identifier_names, invalid_element_content

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_blog/models/blog_post.dart';
import 'package:jaspr_blog/posts/blog_post_registry.dart';

class BlogPostDartWebDevelopment extends Component implements BlogPost {
  const BlogPostDartWebDevelopment();
  
  @override
  Element createElement() => createElement();
  
  @override
  String get title => 'Modern Web Development with Dart';
  
  @override
  String get slug => 'dart-web-development';
  
  @override
  DateTime get publishedAt => DateTime.parse('2024-02-15');
  
  @override
  List<String> get tags => ['dart', 'web', 'development', 'frontend'];
  
  @override
  String get description => 'Explore the world of modern web development using Dart and its powerful ecosystem. Learn how Dart can be used to create fast, scalable, and maintainable web applications.';
  
  @override
  String get author => 'John Doe';
  
  @override
  String? get imageUrl => 'https://images.unsplash.com/photo-1461749280684-dccba630e2f6';
  
  @override
  String? get authorImageUrl => null;
  
  @override
  Map<String, String> get metadata => {
    'author_image': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e'
  };
  
  static final String _rawMarkdown = r"""# Modern Web Development with Dart

Web development has evolved significantly over the years, and Dart has emerged as a powerful language for building modern web applications. In this post, we'll explore how Dart can be used for web development and why it might be the right choice for your next project.

## Why Dart for Web Development?

Dart offers several advantages for web development:

1. **Strong Type System**: Catch errors at compile-time rather than runtime
2. **Rich Ecosystem**: Access to a wide range of packages and tools
3. **Modern Language Features**: Async/await, null safety, and more
4. **Great Developer Tools**: Excellent IDE support and debugging capabilities

## Getting Started

To start developing web applications with Dart, you'll need to:

1. Install the Dart SDK
2. Choose a web framework (e.g., Jaspr, AngularDart)
3. Set up your development environment

Here's a simple example of a Dart web component:

```dart
import 'package:jaspr/jaspr.dart';

class HelloWorld extends StatelessComponent {
  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div([
      h1([text('Hello, World!')]),
      p([text('Welcome to Dart web development')]),
    ]);
  }
}
```

## Best Practices

When developing web applications with Dart, consider these best practices:

- Use strong typing whenever possible
- Leverage Dart's async/await for handling asynchronous operations
- Implement proper error handling
- Follow the platform's conventions and patterns
- Write testable code

## Tools and Libraries

Some essential tools and libraries for Dart web development:

- **build_runner**: For code generation and asset building
- **build_web_compilers**: For compiling Dart to JavaScript
- **jaspr**: A modern web framework for Dart
- **http**: For making HTTP requests
- **json_serializable**: For JSON serialization/deserialization

## Performance Considerations

Dart web applications can be highly performant when following these guidelines:

1. Minimize the size of your JavaScript bundle
2. Implement proper caching strategies
3. Use lazy loading when appropriate
4. Optimize asset loading
5. Implement efficient state management

## Conclusion

Dart is a powerful language for modern web development, offering a great balance of features, performance, and developer experience. Whether you're building a simple website or a complex web application, Dart provides the tools and ecosystem you need to succeed.

Stay tuned for more posts about Dart web development best practices and advanced techniques!""";
  
  @override
  String get markdownContent => _rawMarkdown;
  
  @override
  String get content => r"""<h1>Modern Web Development with Dart</h1>
<p>
Web development has evolved significantly over the years, and Dart has emerged as a powerful language for building modern web applications. In this post, we\'ll explore how Dart can be used for web development and why it might be the right choice for your next project.</p>
<h2>Why Dart for Web Development?</h2>
<p>
Dart offers several advantages for web development:</p>
<p>1. <strong>Strong Type System</strong>: Catch errors at compile-time rather than runtime
2. <strong>Rich Ecosystem</strong>: Access to a wide range of packages and tools
3. <strong>Modern Language Features</strong>: Async/await, null safety, and more
4. <strong>Great Developer Tools</strong>: Excellent IDE support and debugging capabilities</p>
<h2>Getting Started</h2>
<p>
To start developing web applications with Dart, you\'ll need to:</p>
<p>1. Install the Dart SDK
2. Choose a web framework (e.g., Jaspr, AngularDart)
3. Set up your development environment</p>
<p>
Here\'s a simple example of a Dart web component:</p>
<pre><code class="language-dart">import \'package:jaspr/jaspr.dart\';

class HelloWorld extends StatelessComponent {
  @override
  Iterable&lt;Component&gt; build(BuildContext context) sync* {
    yield div([
      h1([text(\'Hello, World!\')]),
      p([text(\'Welcome to Dart web development\')]),
    ]);
  }
}
</code></pre>
<h2>Best Practices</h2>
<p>
When developing web applications with Dart, consider these best practices:</p>
<p>- Use strong typing whenever possible</p>
<p>- Leverage Dart\'s async/await for handling asynchronous operations</p>
<p>- Implement proper error handling</p>
<p>- Follow the platform\'s conventions and patterns</p>
<p>- Write testable code</p>
<h2>Tools and Libraries</h2>
<p>
Some essential tools and libraries for Dart web development:</p>
<p>- <strong>build_runner</strong>: For code generation and asset building</p>
<p>- <strong>build_web_compilers</strong>: For compiling Dart to JavaScript</p>
<p>- <strong>jaspr</strong>: A modern web framework for Dart</p>
<p>- <strong>http</strong>: For making HTTP requests</p>
<p>- <strong>json_serializable</strong>: For JSON serialization/deserialization</p>
<h2>Performance Considerations</h2>
<p>
Dart web applications can be highly performant when following these guidelines:</p>
<p>1. Minimize the size of your JavaScript bundle
2. Implement proper caching strategies
3. Use lazy loading when appropriate
4. Optimize asset loading
5. Implement efficient state management</p>
<h2>Conclusion</h2>
<p>
Dart is a powerful language for modern web development, offering a great balance of features, performance, and developer experience. Whether you\'re building a simple website or a complex web application, Dart provides the tools and ecosystem you need to succeed.</p>
<p>
Stay tuned for more posts about Dart web development best practices and advanced techniques!</p>""";
  
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
  String get canonicalUrl => '/blog/dart-web-development';
  
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
  registerPostFactory(() => const BlogPostDartWebDevelopment());
}
