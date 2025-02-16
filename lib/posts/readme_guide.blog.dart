// Generated code - do not modify by hand
// ignore_for_file: undefined_identifier, expected_identifier, invalid_reference_to_this, non_constant_identifier_names, constant_identifier_names, invalid_element_content

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_blog/models/blog_post.dart';
import 'package:jaspr_blog/posts/blog_post_registry.dart';

class BlogPostReadmeGuide extends Component implements BlogPost {
  const BlogPostReadmeGuide();
  
  @override
  Element createElement() => createElement();
  
  @override
  String get title => 'How to Use This Blog';
  
  @override
  String get slug => 'readme_guide';
  
  @override
  DateTime get publishedAt => DateTime.parse('2024-03-20');
  
  @override
  List<String> get tags => ['guide', 'jaspr', 'documentation'];
  
  @override
  String get description => 'A comprehensive guide on how to use and contribute to this Jaspr-powered blog';
  
  @override
  String get author => 'Temitope Ajiboye';
  
  @override
  String? get imageUrl => 'https://images.unsplash.com/photo-1499750310107-5fef28a66643';
  
  @override
  String? get authorImageUrl => 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e';
  
  @override
  Map<String, String> get metadata => {
    
  };
  
  static final String _rawMarkdown = r"""# How to Use This Blog

Welcome to our Jaspr-powered blog! This guide will walk you through how to use, navigate, and contribute to this blog platform.

## Features

### 1. Markdown Support
All blog posts are written in Markdown, making it easy to:
- Write formatted content
- Include code snippets
- Add images and links
- Create tables

### 2. Code Highlighting
```dart
void main() {
  print('Hello, Jaspr!');
}
```

### 3. Automatic Post Generation
Adding a new post is as simple as:
1. Create a new `.md` file in `lib/posts`
2. Add the required frontmatter
3. Write your content
4. Run `dart run build_runner build`

## Contributing

To contribute a new blog post:

1. Fork the repository
2. Create your post in the `lib/posts` directory
3. Ensure your frontmatter includes:
   - title
   - date
   - author
   - description
   - tags
4. Submit a pull request

## Post Structure

Each post should follow this structure:

```markdown
---
title: Your Post Title
date: YYYY-MM-DD
author: Your Name
description: A brief description
tags: [tag1, tag2]
---

# Main Title

Your content here...
```

## Tables

| Feature | Description | Status |
|---------|-------------|---------|
| Markdown | Full markdown support | ✅ |
| Code Highlighting | Syntax highlighting for code | ✅ |
| Auto-generation | Automatic post registration | ✅ |
| SSR | Server-side rendering | ✅ |

## Images

![Writing](https://images.unsplash.com/photo-1455390582262-044cdead277a)

## Conclusion

This blog platform makes it easy to:
1. Write posts in Markdown
2. Automatically generate blog components
3. Maintain a consistent structure
4. Focus on content creation

For more information, check out the [Jaspr documentation](https://docs.page/schultek/jaspr).""";
  
  @override
  String get markdownContent => _rawMarkdown;
  
  @override
  String get content => r"""<h1>How to Use This Blog</h1>
<p>
Welcome to our Jaspr-powered blog! This guide will walk you through how to use, navigate, and contribute to this blog platform.</p>
<h2>Features</h2>
<h3>1. Markdown Support</h3>
<p>All blog posts are written in Markdown, making it easy to:</p>
<p>- Write formatted content</p>
<p>- Include code snippets</p>
<p>- Add images and links</p>
<p>- Create tables</p>
<h3>2. Code Highlighting</h3>
<pre><code class="language-dart">void main() {
  print(\'Hello, Jaspr!\');
}
</code></pre>
<h3>3. Automatic Post Generation</h3>
<p>Adding a new post is as simple as:</p>
<p>1. Create a new <code>.md</code> file in <code>lib/posts</code>
2. Add the required frontmatter
3. Write your content
4. Run <code>dart run build_runner build</code></p>
<h2>Contributing</h2>
<p>
To contribute a new blog post:</p>
<p>1. Fork the repository
2. Create your post in the <code>lib/posts</code> directory
3. Ensure your frontmatter includes:</p>
<p>- title</p>
<p>- date</p>
<p>- author</p>
<p>- description</p>
<p>- tags
4. Submit a pull request</p>
<h2>Post Structure</h2>
<p>
Each post should follow this structure:</p>
<pre><code class="language-markdown">---
title: Your Post Title
date: YYYY-MM-DD
author: Your Name
description: A brief description
tags: [tag1, tag2]
---

# Main Title

Your content here...
</code></pre>
<h2>Tables</h2>
<table>
<thead>
<tr>
<th>Feature</th>
<th>Description</th>
<th>Status</th>
</tr>
</thead>
<tbody>
<tr>
<td>Markdown</td>
<td>Full markdown support</td>
<td>✅</td>
</tr>
<tr>
<td>Code Highlighting</td>
<td>Syntax highlighting for code</td>
<td>✅</td>
</tr>
<tr>
<td>Auto-generation</td>
<td>Automatic post registration</td>
<td>✅</td>
</tr>
<tr>
<td>SSR</td>
<td>Server-side rendering</td>
<td>✅</td>
</tr>
</tbody>
</table>
<h2>Images</h2>
<p>
<img src="https://images.unsplash.com/photo-1455390582262-044cdead277a" alt="Writing" /></p>
<h2>Conclusion</h2>
<p>
This blog platform makes it easy to:</p>
<p>1. Write posts in Markdown
2. Automatically generate blog components
3. Maintain a consistent structure
4. Focus on content creation</p>
<p>
For more information, check out the <a href="https://docs.page/schultek/jaspr">Jaspr documentation</a>.</p>""";
  
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
  String get canonicalUrl => '/blog/readme_guide';
  
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
  registerPostFactory(() => const BlogPostReadmeGuide());
}
