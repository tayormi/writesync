import 'package:jaspr/dom.dart';
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
  Component build(BuildContext context) {
    return Component.fragment([
      meta(
        attributes: {'name': 'title', 'content': title},
      ),
      meta(
        attributes: {'name': 'description', 'content': description},
      ),
  
      if (keywords.isNotEmpty) 
        meta(
          attributes: {'name': 'keywords', 'content': keywords.join(', ')},
        ),
      
  
      if (author.isNotEmpty) 
        meta(
          attributes: {'name': 'author', 'content': author},
        ),
      
  
      // Open Graph tags for social media
      meta(
        attributes: {'property': 'og:title', 'content': title},
      ),
      meta(
        attributes: {'property': 'og:description', 'content': description},
      ),
      meta(
        attributes: {'property': 'og:type', 'content': 'article'},
      ),
  
      if (canonicalUrl != null) ...[
        meta(
          attributes: {'property': 'og:url', 'content': canonicalUrl!},
        ),
        link(
          href: canonicalUrl!,
          attributes: {'rel': 'canonical'},
        ),
      ],
  
      // Twitter Card tags
      meta(
        attributes: {'name': 'twitter:card', 'content': 'summary'},
      ),
      meta(
        attributes: {'name': 'twitter:title', 'content': title},
      ),
      meta(
        attributes: {'name': 'twitter:description', 'content': description},
      ),
    ]);
  }
}
