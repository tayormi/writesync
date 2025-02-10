import 'package:jaspr/jaspr.dart';
import 'package:intl/intl.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../models/blog_post.dart';
import '../config/site_config.dart';
import '../providers/theme_provider.dart';
import 'tag_chip.dart';

class BlogPostComponent extends StatefulComponent {
  final BlogPost post;

  const BlogPostComponent({
    required this.post,
  });

  @override
  State<BlogPostComponent> createState() => _BlogPostComponentState();
}

class _BlogPostComponentState extends State<BlogPostComponent> {
  @override
  Iterable<Component> build(BuildContext context) sync* {
    final isDark = context.watch(isDarkProvider);

    // Use Document.head() for SEO
    yield Document.head(
      title: '${component.post.title} - Jaspr Blog',
      meta: {
        'description': component.post.metaDescription,
        'author': component.post.author,
        'keywords': component.post.tags.join(', '),
        'og:title': component.post.title,
        'og:description': component.post.metaDescription,
        'og:type': 'article',
        if (component.post.imageUrl != null)
          'og:image': component.post.imageUrl!,
        'twitter:card': 'summary_large_image',
        'twitter:title': component.post.title,
        'twitter:description': component.post.metaDescription,
        if (component.post.imageUrl != null)
          'twitter:image': component.post.imageUrl!,
      },
    );

    yield article(classes: 'bg-white py-24 sm:py-32', [
      div(classes: 'mx-auto max-w-7xl px-6 lg:px-8', [
        div(classes: 'mx-auto max-w-3xl', [
          div(classes: 'mx-auto max-w-2xl text-center', [
            div(classes: 'mt-8 flex justify-center gap-x-4 text-xs', [
              DomComponent(
                tag: 'time',
                classes: 'text-gray-500',
                attributes: {
                  'datetime': component.post.publishedAt.toIso8601String()
                },
                children: [
                  text(component.post.publishedAt
                      .toLocal()
                      .toString()
                      .split(' ')[0])
                ],
              ),
              for (final tag in component.post.tags)
                a(
                  href: '/tags/${tag.toLowerCase()}',
                  classes:
                      'relative z-10 rounded-full ${SiteConfig.getPrimaryLightClasses(isDark: isDark)} px-3 py-1.5 font-medium',
                  [text(tag)],
                ),
            ]),
            h1(
                classes:
                    'mt-8 text-4xl font-bold tracking-tight text-gray-900 sm:text-5xl',
                [
                  text(component.post.title),
                ]),
            div(classes: 'mt-6 text-lg leading-8 text-gray-600', [
              text(component.post.description),
            ]),
            div(classes: 'mt-8 flex justify-center', [
              div(classes: 'flex items-center gap-x-4', [
                span(classes: 'text-gray-600 text-sm', [text('By')]),
                span(
                    classes: 'font-semibold text-gray-900',
                    [text(component.post.author)]),
              ]),
            ]),
          ]),
          div(
            classes:
                'prose prose-lg mx-auto prose-img:rounded-xl prose-headings:font-semibold ${SiteConfig.getPrimaryTextClasses(isDark: isDark)}',
            attributes: {
              'innerHTML': md.markdownToHtml(
                component.post.markdownContent,
                extensionSet: md.ExtensionSet.gitHubWeb,
              ),
            },
            [],
          ),
        ]),
      ]),
    ]);
  }
}

class BlogPostCard extends StatelessComponent {
  final BlogPost post;

  const BlogPostCard({
    required this.post,
    super.key,
  });

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield article(
      classes:
          'bg-white dark:bg-gray-800 rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-shadow duration-300',
      [
        if (post.imageUrl != null)
          img(
            src: post.imageUrl!,
            classes: 'w-full h-48 object-cover',
            alt: post.title,
          ),
        div(
          classes: 'p-6',
          [
            // Tags
            if (SiteConfig.blogDisplay['showTags']! && post.tags.isNotEmpty)
              div(
                classes: 'mb-4 flex flex-wrap gap-2',
                [
                  for (final tag in post.tags) TagChip(tag: tag),
                ],
              ),

            // Title
            a(
              href: post.canonicalUrl,
              classes: 'block',
              [
                h2(
                  classes:
                      'text-xl font-semibold text-gray-900 dark:text-white mb-2 hover:text-blue-600 dark:hover:text-blue-400',
                  [text(post.title)],
                ),
              ],
            ),

            // Description
            p(
              classes: 'text-gray-600 dark:text-gray-400 mb-4',
              [text(post.description)],
            ),

            // Metadata
            if (SiteConfig.blogDisplay['showAuthor']! ||
                SiteConfig.blogDisplay['showDate']!)
              div(
                classes:
                    'flex items-center justify-between text-sm text-gray-500 dark:text-gray-400',
                [
                  // Author
                  if (SiteConfig.blogDisplay['showAuthor']!)
                    div(
                      classes: 'flex items-center',
                      [
                        if (SiteConfig.blogDisplay['showAuthorImage']! &&
                            post.authorImageUrl != null)
                          img(
                            src: post.authorImageUrl!,
                            classes: 'w-6 h-6 rounded-full mr-2',
                            alt: post.author,
                          ),
                        text(post.author),
                      ],
                    ),
                  // Date
                  if (SiteConfig.blogDisplay['showDate']!)
                    text(DateFormat('MMM d, yyyy').format(post.publishedAt)),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
