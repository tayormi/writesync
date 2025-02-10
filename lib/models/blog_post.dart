import 'package:meta/meta.dart';

@immutable
class BlogPost {
  final String title;
  final String slug;
  final String markdownContent;
  final DateTime publishedAt;
  final List<String> tags;
  final String description;
  final String author;
  final String? imageUrl;
  final String? authorImageUrl;
  final Map<String, String> metadata;
  final String content;

  const BlogPost({
    required this.title,
    required this.slug,
    required this.markdownContent,
    required this.publishedAt,
    required this.tags,
    required this.description,
    required this.author,
    this.imageUrl,
    this.authorImageUrl,
    required this.metadata,
    required this.content,
  });

  factory BlogPost.fromMarkdown(
      String content, Map<String, dynamic> frontMatter) {
    return BlogPost(
      title: frontMatter['title'] as String? ?? 'Untitled',
      slug: frontMatter['slug'] as String? ?? 'untitled',
      markdownContent: content,
      publishedAt: DateTime.tryParse(frontMatter['date'] as String? ?? '') ??
          DateTime.now(),
      tags: (frontMatter['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      description: frontMatter['description'] as String? ?? '',
      author: frontMatter['author'] as String? ?? 'Anonymous',
      imageUrl: frontMatter['image'] as String?,
      authorImageUrl: frontMatter['author_image'] as String?,
      metadata: Map<String, String>.from(frontMatter['metadata'] as Map? ?? {}),
      content: content,
    );
  }

  String get metaDescription => description.isEmpty
      ? markdownContent.substring(
          0, markdownContent.length > 160 ? 160 : markdownContent.length)
      : description;

  String get canonicalUrl => '/blog/$slug';
}
