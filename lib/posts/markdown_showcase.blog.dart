// Generated code - do not modify by hand
// ignore_for_file: undefined_identifier, expected_identifier, invalid_reference_to_this, non_constant_identifier_names, constant_identifier_names, invalid_element_content

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_blog/models/blog_post.dart';
import 'package:jaspr_blog/posts/blog_post_registry.dart';

class BlogPostMarkdownShowcase extends Component implements BlogPost {
  const BlogPostMarkdownShowcase();
  
  @override
  Element createElement() => createElement();
  
  @override
  String get title => 'Markdown Showcase - Everything You Can Do';
  
  @override
  String get slug => 'markdown-showcase';
  
  @override
  DateTime get publishedAt => DateTime.parse('2024-02-01');
  
  @override
  List<String> get tags => ['markdown', 'tutorial', 'showcase'];
  
  @override
  String get description => 'A comprehensive showcase of all markdown features and content types supported in our blog';
  
  @override
  String get author => 'John Doe';
  
  @override
  String? get imageUrl => 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97';
  
  @override
  String? get authorImageUrl => null;
  
  @override
  Map<String, String> get metadata => {
    'author_image': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e',
    'metadata': '{readTime: 8 min}'
  };
  
  static final String _rawMarkdown = r"""# Markdown Showcase

This post demonstrates all the markdown features and content types supported in our blog.

## Text Formatting

Basic text formatting includes:
- **Bold text** using double asterisks
- *Italic text* using single asterisks
- ***Bold and italic*** using triple asterisks
- ~~Strikethrough~~ using double tildes
- `Inline code` using backticks
- [Links](https://example.com) using square brackets and parentheses
- Footnotes[^1] using caret notation

## Lists

### Unordered Lists
- First item
- Second item
  - Nested item 1
  - Nested item 2
- Third item

### Ordered Lists
1. First step
2. Second step
   1. Nested step 1
   2. Nested step 2
3. Third step

### Task Lists
- [x] Completed task
- [ ] Incomplete task
- [x] Another completed task

## Code Blocks

Inline code: `const greeting = "Hello, World!";`

Code block with syntax highlighting:

```dart
void main() {
  final message = 'Hello, Markdown!';
  print(message);
  
  // This is a comment
  for (var i = 0; i < 5; i++) {
    print('Count: $i');
  }
}
```

```javascript
// JavaScript example
function greet(name) {
  return `Hello, ${name}!`;
}

console.log(greet('Developer'));
```

## Blockquotes

> Single line blockquote

> Multi-line blockquote
> with multiple paragraphs
> and continued text

## Tables

| Feature | Description | Support |
|---------|-------------|---------|
| Tables | Basic tables with headers | ✅ |
| Lists | Ordered and unordered lists | ✅ |
| Code | Syntax highlighting | ✅ |
| Images | Inline and referenced | ✅ |

## Images

### Regular Image
![Coding Setup](https://images.unsplash.com/photo-1461749280684-dccba630e2f6)

### Image with Custom Size (HTML)
<img src="https://images.unsplash.com/photo-1498050108023-c5249f4df085" width="400" alt="Developer workspace">

### Image with Caption
![Developer Tools](https://images.unsplash.com/photo-1555099962-4199c345e5dd)
*Modern development tools and workspace*

## Videos

### YouTube Embed
<iframe width="560" height="315" src="https://www.youtube.com/embed/dQw4w9WgXcQ" frameborder="0" allowfullscreen></iframe>

### Vimeo Embed
<iframe src="https://player.vimeo.com/video/123456789" width="560" height="315" frameborder="0" allowfullscreen></iframe>

## Mathematical Equations

Inline math: $E = mc^2$

Block math:
$$
\frac{n!}{k!(n-k)!} = \binom{n}{k}
$$

## Diagrams (Mermaid)

```mermaid
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
```

## Horizontal Rules

Three different styles:

---
***
___

## Special Characters & Emoji

Special characters: &copy; &reg; &trade;

Emoji: 🚀 💻 🎉 👨‍💻 

## HTML Elements

<div style="background-color: #f0f0f0; padding: 1rem; border-radius: 4px;">
  <h3>Custom HTML Block</h3>
  <p>This is a custom HTML block with styling</p>
</div>

<details>
<summary>Click to expand</summary>
This is expandable/collapsible content using HTML details tag.
</details>

## Keyboard Keys

Use <kbd>Ctrl</kbd> + <kbd>C</kbd> to copy text.

## Definition Lists

HTML
: HyperText Markup Language, the standard markup language for web pages.

CSS
: Cascading Style Sheets, used for describing the presentation of a document.

## Abbreviations

The <abbr title="World Wide Web Consortium">W3C</abbr> is the main international standards organization for the World Wide Web.

## Footnotes

[^1]: This is a footnote with a detailed explanation.

## Final Notes

This document showcases most markdown features. Some features might require additional plugins or configurations to work properly.""";
  
  @override
  String get markdownContent => _rawMarkdown;
  
  @override
  String get content => r"""<h1>Markdown Showcase</h1>
<p>
This post demonstrates all the markdown features and content types supported in our blog.</p>
<h2>Text Formatting</h2>
<p>
Basic text formatting includes:</p>
<p>- <strong>Bold text</strong> using double asterisks</p>
<p>- <em>Italic text</em> using single asterisks</p>
<p>- <em><strong>Bold and italic</strong></em> using triple asterisks</p>
<p>- <del>Strikethrough</del> using double tildes</p>
<p>- <code>Inline code</code> using backticks</p>
<p>- <a href="https://example.com">Links</a> using square brackets and parentheses</p>
<p>- Footnotes[^1] using caret notation</p>
<h2>Lists</h2>
<h3>Unordered Lists</h3>
<p>- First item</p>
<p>- Second item</p>
<p>- Nested item 1</p>
<p>- Nested item 2</p>
<p>- Third item</p>
<h3>Ordered Lists</h3>
<p>1. First step
2. Second step</p>
<p>1. Nested step 1
2. Nested step 2
3. Third step</p>
<h3>Task Lists</h3>
<p>- [x] Completed task</p>
<p>- [ ] Incomplete task</p>
<p>- [x] Another completed task</p>
<h2>Code Blocks</h2>
<p>
Inline code: <code>const greeting = &quot;Hello, World!&quot;;</code></p>
<p>
Code block with syntax highlighting:</p>
<pre><code class="language-dart">void main() {
  final message = \'Hello, Markdown!\';
  print(message);
  
  // This is a comment
  for (var i = 0; i &lt; 5; i++) {
    print(\'Count: $i\');
  }
}
</code></pre>
<pre><code class="language-javascript">// JavaScript example
function greet(name) {
  return `Hello, ${name}!`;
}

console.log(greet(\'Developer\'));
</code></pre>
<h2>Blockquotes</h2>
<blockquote>
<p>Single line blockquote</p>
<p>
Multi-line blockquote
with multiple paragraphs
and continued text</p>
</blockquote>
<h2>Tables</h2>
<table>
<thead>
<tr>
<th>Feature</th>
<th>Description</th>
<th>Support</th>
</tr>
</thead>
<tbody>
<tr>
<td>Tables</td>
<td>Basic tables with headers</td>
<td>✅</td>
</tr>
<tr>
<td>Lists</td>
<td>Ordered and unordered lists</td>
<td>✅</td>
</tr>
<tr>
<td>Code</td>
<td>Syntax highlighting</td>
<td>✅</td>
</tr>
<tr>
<td>Images</td>
<td>Inline and referenced</td>
<td>✅</td>
</tr>
</tbody>
</table>
<h2>Images</h2>
<h3>Regular Image</h3>
<p><img src="https://images.unsplash.com/photo-1461749280684-dccba630e2f6" alt="Coding Setup" /></p>
<h3>Image with Custom Size (HTML)</h3>
<p><img src="https://images.unsplash.com/photo-1498050108023-c5249f4df085" width="400" alt="Developer workspace"></p>
<h3>Image with Caption</h3>
<p><img src="https://images.unsplash.com/photo-1555099962-4199c345e5dd" alt="Developer Tools" />
<em>Modern development tools and workspace</em></p>
<h2>Videos</h2>
<h3>YouTube Embed</h3>
<p><iframe width="560" height="315" src="https://www.youtube.com/embed/dQw4w9WgXcQ" frameborder="0" allowfullscreen></iframe></p>
<h3>Vimeo Embed</h3>
<p><iframe src="https://player.vimeo.com/video/123456789" width="560" height="315" frameborder="0" allowfullscreen></iframe></p>
<h2>Mathematical Equations</h2>
<p>
Inline math: $E = mc^2$</p>
<p>
Block math:
$$
\\frac{n!}{k!(n-k)!} = \\binom{n}{k}
$$</p>
<h2>Diagrams (Mermaid)</h2>
<pre><code class="language-mermaid">graph TD;
    A--&gt;B;
    A--&gt;C;
    B--&gt;D;
    C--&gt;D;
</code></pre>
<h2>Horizontal Rules</h2>
<p>
Three different styles:</p>
<hr />
<hr />
<hr />
<h2>Special Characters &amp; Emoji</h2>
<p>
Special characters: © ® ™</p>
<p>
Emoji: 🚀 💻 🎉 👨‍💻</p>
<h2>HTML Elements</h2>
<p><div style="background-color: #f0f0f0; padding: 1rem; border-radius: 4px;"></p>
<p><h3>Custom HTML Block</h3></p>
<p><p>This is a custom HTML block with styling</p></p>
<p></div></p>
<p><details></p>
<p><summary>Click to expand</summary>
This is expandable/collapsible content using HTML details tag.</p>
<p></details></p>
<h2>Keyboard Keys</h2>
<p>
Use <kbd>Ctrl</kbd> + <kbd>C</kbd> to copy text.</p>
<h2>Definition Lists</h2>
<p>
HTML
: HyperText Markup Language, the standard markup language for web pages.</p>
<p>
CSS
: Cascading Style Sheets, used for describing the presentation of a document.</p>
<h2>Abbreviations</h2>
<p>
The <abbr title="World Wide Web Consortium">W3C</abbr> is the main international standards organization for the World Wide Web.</p>
<h2>Footnotes</h2>
<p>[^1]: This is a footnote with a detailed explanation.</p>
<h2>Final Notes</h2>
<p>
This document showcases most markdown features. Some features might require additional plugins or configurations to work properly.</p>""";
  
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
  String get canonicalUrl => '/blog/markdown-showcase';
  
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
  registerPostFactory(() => const BlogPostMarkdownShowcase());
}
