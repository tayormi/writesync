import 'package:jaspr/jaspr.dart';
import '../models/blog_post.dart';

class SeoHead extends StatelessComponent {
  final String title;
  final String description;
  final String? canonicalUrl;
  final List<String> keywords;
  final String author;

  const SeoHead({
    required this.title,
    required this.description,
    this.canonicalUrl,
    this.keywords = const [],
    this.author = '',
  });

  factory SeoHead.fromBlogPost(BlogPost post) {
    return SeoHead(
      title: post.title,
      description: post.metaDescription,
      canonicalUrl: post.canonicalUrl,
      keywords: post.tags,
      author: post.author,
    );
  }

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield meta(
      attributes: {'name': 'title', 'content': title},
    );
    yield meta(
      attributes: {'name': 'description', 'content': description},
    );

    if (keywords.isNotEmpty) {
      yield meta(
        attributes: {'name': 'keywords', 'content': keywords.join(', ')},
      );
    }

    if (author.isNotEmpty) {
      yield meta(
        attributes: {'name': 'author', 'content': author},
      );
    }

    // Open Graph tags for social media
    yield meta(
      attributes: {'property': 'og:title', 'content': title},
    );
    yield meta(
      attributes: {'property': 'og:description', 'content': description},
    );
    yield meta(
      attributes: {'property': 'og:type', 'content': 'article'},
    );

    if (canonicalUrl != null) {
      yield meta(
        attributes: {'property': 'og:url', 'content': canonicalUrl!},
      );
      yield link(
        href: canonicalUrl!,
        attributes: {'rel': 'canonical'},
      );
    }

    // Twitter Card tags
    yield meta(
      attributes: {'name': 'twitter:card', 'content': 'summary'},
    );
    yield meta(
      attributes: {'name': 'twitter:title', 'content': title},
    );
    yield meta(
      attributes: {'name': 'twitter:description', 'content': description},
    );
  }
}
