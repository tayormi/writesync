import 'package:jaspr/jaspr.dart';
import 'package:intl/intl.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../models/blog_post.dart';
import '../config/site_config.dart';
import '../providers/theme_provider.dart';
import '../providers/layout_provider.dart';
import '../mixins/monitoring_mixin.dart';

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

class BlogPostCard extends StatefulComponent {
  final BlogPost post;

  const BlogPostCard({
    required this.post,
    super.key,
  });

  @override
  State<BlogPostCard> createState() => _BlogPostCardState();
}

class _BlogPostCardState extends State<BlogPostCard>
    with MonitoringMixin<BlogPostCard> {
  void _handlePostClick() {
    trackComponentInteraction(
      'post_card',
      'click',
      properties: {
        'post_slug': component.post.slug,
        'post_title': component.post.title,
      },
    );
  }

  @override
  Iterable<Component> build(BuildContext context) sync* {
    final currentLayout = context.watch(blogLayoutProvider);
    final isListView = currentLayout == BlogLayout.list;

    yield article(
      classes: '''
        ${SiteConfig.blogPostCard['container']}
        ${isListView ? SiteConfig.blogPostCard['listView']!['container'] : ''}
      ''',
      [
        if (component.post.imageUrl != null)
          div(
            classes: '''
              ${SiteConfig.blogPostCard['imageContainer']}
              ${isListView ? SiteConfig.blogPostCard['listView']!['imageContainer'] : ''} 
            ''',
            [
              img(
                src: component.post.imageUrl!,
                classes: SiteConfig.blogPostCard['image'],
                alt: component.post.title,
              ),
            ],
          ),
        div(
          classes: '''
            ${SiteConfig.blogPostCard['content']}
            ${isListView ? SiteConfig.blogPostCard['listView']!['content'] : ''}
          ''',
          [
            div(
              classes: SiteConfig.blogPostCard['contentWrapper'],
              [
                // Title
                a(
                  href: component.post.canonicalUrl,
                  classes: SiteConfig.blogPostCard['title'],
                  events: {
                    'click': (event) => _handlePostClick(),
                  },
                  [text(component.post.title)],
                ),
                // Description
                p(
                  classes: SiteConfig.blogPostCard['description'],
                  [text(component.post.description)],
                ),
              ],
            ),
            // Author section
            if (SiteConfig.blogDisplay['showAuthor'] == true ||
                SiteConfig.blogDisplay['showAuthorImage'] == true ||
                SiteConfig.blogDisplay['showDate'] == true)
              div(
                classes: SiteConfig.blogPostCard['authorContainer'],
                [
                  if (SiteConfig.blogDisplay['showAuthorImage'] == true)
                    a(
                      href: '#',
                      events: {
                        'click': (event) {
                          trackComponentInteraction(
                            'author_image',
                            'click',
                            properties: {
                              'author': component.post.author,
                              'post_slug': component.post.slug,
                            },
                          );
                        },
                      },
                      [
                        img(
                          src: component.post.authorImageUrl ??
                              SiteConfig.defaultAuthorImage,
                          classes: SiteConfig.blogPostCard['authorImage'],
                          alt: 'Avatar of ${component.post.author}',
                        ),
                      ],
                    ),
                  div(
                    classes: SiteConfig.blogPostCard['authorInfo'],
                    [
                      if (SiteConfig.blogDisplay['showAuthor'] == true)
                        a(
                          href: '#',
                          classes: SiteConfig.blogPostCard['authorName'],
                          events: {
                            'click': (event) {
                              trackComponentInteraction(
                                'author_name',
                                'click',
                                properties: {
                                  'author': component.post.author,
                                  'post_slug': component.post.slug,
                                },
                              );
                            },
                          },
                          [text(component.post.author)],
                        ),
                      if (SiteConfig.blogDisplay['showDate'] == true)
                        p(
                          classes: SiteConfig.blogPostCard['date'],
                          [
                            text(DateFormat('MMM d')
                                .format(component.post.publishedAt)),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
