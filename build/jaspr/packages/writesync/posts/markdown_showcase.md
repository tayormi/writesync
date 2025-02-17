---
title: Markdown Showcase - Everything You Can Do
slug: markdown-showcase
date: 2024-02-01
tags: [markdown, tutorial, showcase]
description: A comprehensive showcase of all markdown features and content types supported in our blog
author: John Doe
image: https://images.unsplash.com/photo-1517694712202-14dd9538aa97
author_image: https://images.unsplash.com/photo-1472099645785-5658abf4ff4e
metadata:
  readTime: 8 min
---

# Markdown Showcase

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

This document showcases most markdown features. Some features might require additional plugins or configurations to work properly. 