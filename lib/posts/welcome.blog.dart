// Generated code - do not modify by hand
// ignore_for_file: undefined_identifier, expected_identifier, invalid_reference_to_this, non_constant_identifier_names, constant_identifier_names, invalid_element_content

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_blog/models/blog_post.dart';
import 'package:jaspr_blog/posts/blog_post_registry.dart';

class BlogPostWelcome extends Component implements BlogPost {
  const BlogPostWelcome();
  
  @override
  Element createElement() => createElement();
  
  @override
  String get title => 'Welcome to My Blog';
  
  @override
  String get slug => 'welcome';
  
  @override
  DateTime get publishedAt => DateTime.parse('2024-01-28');
  
  @override
  List<String> get tags => ['welcome', 'first-post'];
  
  @override
  String get description => 'Welcome to my new blog built with Jaspr';
  
  @override
  String get author => 'John Doe';
  
  @override
  String? get imageUrl => null;
  
  @override
  String? get authorImageUrl => null;
  
  @override
  Map<String, String> get metadata => {
    
  };
  
  static final String _rawMarkdown = r"""# Welcome to My Blog

This is my first blog post using Jaspr and Markdown! This blog engine is built with Jaspr, a modern web framework for Dart that allows you to create fast, SEO-friendly websites.

## Features

- Markdown support with frontmatter
- SEO optimization
- Clean and responsive design
- Fast client-side navigation
- Tag support

## Code Example

Here's a simple Dart code example:

```dart
void main() {
  print('Hello, Blog!');
}
```

## What's Next?

Stay tuned for more posts about:
- Dart programming
- Web development
- Best practices
- And much more!""";
  
  @override
  String get markdownContent => _rawMarkdown;
  
  @override
  String get content => r"""<h1>Welcome to My Blog</h1>
<p>
This is my first blog post using Jaspr and Markdown! This blog engine is built with Jaspr, a modern web framework for Dart that allows you to create fast, SEO-friendly websites.</p>
<h2>Features</h2>
<p>- Markdown support with frontmatter</p>
<p>- SEO optimization</p>
<p>- Clean and responsive design</p>
<p>- Fast client-side navigation</p>
<p>- Tag support</p>
<h2>Code Example</h2>
<p>
Here\'s a simple Dart code example:</p>
<pre><code class="language-dart">void main() {
  print(\'Hello, Blog!\');
}
</code></pre>
<h2>What\'s Next?</h2>
<p>
Stay tuned for more posts about:</p>
<p>- Dart programming</p>
<p>- Web development</p>
<p>- Best practices</p>
<p>- And much more!</p>""";
  
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
  String get canonicalUrl => '/blog/welcome';
  
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
  registerPostFactory(() => const BlogPostWelcome());
}
