---
title: How to Use This Blog
date: 2024-03-20
author: Temitope Ajiboye
description: A comprehensive guide on how to use and contribute to this Jaspr-powered blog
tags: [guide, jaspr, documentation]
image: https://images.unsplash.com/photo-1499750310107-5fef28a66643
authorImage: https://images.unsplash.com/photo-1472099645785-5658abf4ff4e
---

# How to Use This Blog

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

For more information, check out the [Jaspr documentation](https://docs.page/schultek/jaspr). 