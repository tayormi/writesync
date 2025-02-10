import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../models/blog_post.dart';
import '../config/site_config.dart';
import '../providers/theme_provider.dart';

class FeaturedPost extends StatelessComponent {
  final BlogPost post;

  const FeaturedPost({required this.post});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    final isDark = context.watch(isDarkProvider);

    yield div(
      classes: '',
      [
        // Section header
        div(
          classes: 'flex items-center gap-2 mb-4',
          [
            h2(
              classes: 'text-lg font-semibold text-gray-900 dark:text-white',
              [text('Featured Article')],
            ),
            div(
              classes: 'flex-grow h-px bg-gray-200 dark:bg-gray-700',
              [],
            ),
          ],
        ),
        // Featured post card
        div(
          classes:
              'relative isolate flex flex-col lg:flex-row gap-4 overflow-hidden bg-white dark:bg-gray-800 rounded-xl shadow mb-6',
          [
            // Image section
            div(
              classes:
                  'w-full lg:w-2/5 aspect-[2/1] lg:aspect-[3/2] overflow-hidden',
              [
                if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
                  img(
                    src: post.imageUrl!,
                    classes:
                        'h-full w-full object-cover transition-transform duration-300 hover:scale-105',
                    attributes: {'alt': post.title},
                  ),
              ],
            ),

            // Content section
            div(
              classes: 'flex flex-col justify-between p-3 lg:p-4 lg:w-3/5',
              [
                div([
                  // Tags
                  if (post.tags.isNotEmpty)
                    div(
                      classes: 'flex flex-wrap gap-1.5 mb-2',
                      [
                        for (final tag in post.tags)
                          span(
                            classes:
                                'px-2 py-0.5 text-xs font-medium rounded-full ${SiteConfig.getPrimaryLightClasses(isDark: isDark)}',
                            [text(tag)],
                          ),
                      ],
                    ),

                  // Title
                  h3(
                    classes:
                        'text-lg sm:text-xl font-bold mb-2 text-gray-900 dark:text-white line-clamp-2',
                    [text(post.title)],
                  ),

                  // Description
                  p(
                    classes:
                        'text-sm text-gray-600 dark:text-gray-400 mb-3 line-clamp-2',
                    [text(post.description)],
                  ),
                ]),
                div([
                  // Author and date section
                  div(
                    classes: 'flex items-center gap-2 mb-3',
                    [
                      if (SiteConfig.blogDisplay['showAuthor']!)
                        div(
                          classes: 'flex items-center gap-2',
                          [
                            if (SiteConfig.blogDisplay['showAuthorImage']! &&
                                post.authorImageUrl != null &&
                                post.authorImageUrl!.isNotEmpty)
                              img(
                                src: post.authorImageUrl!,
                                classes: 'h-6 w-6 rounded-full',
                                attributes: {'alt': post.author},
                              ),
                            div(
                              classes: 'text-xs',
                              [
                                p(
                                  classes:
                                      'font-medium text-gray-900 dark:text-white',
                                  [text(post.author)],
                                ),
                                if (SiteConfig.blogDisplay['showDate']!)
                                  DomComponent(
                                    tag: 'time',
                                    classes: 'text-gray-500 dark:text-gray-400',
                                    attributes: {
                                      'datetime':
                                          post.publishedAt.toIso8601String()
                                    },
                                    children: [
                                      text(post.publishedAt
                                          .toLocal()
                                          .toString()
                                          .split(' ')[0])
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),

                  // Read more button
                  a(
                    href: '/blog/${post.slug}',
                    classes:
                        'inline-flex items-center justify-center px-3 py-1.5 text-sm font-medium rounded-lg ${SiteConfig.getPrimaryClasses(isDark: isDark)}',
                    [
                      text('Read more'),
                      DomComponent(
                        tag: 'svg',
                        classes: 'ml-1.5 h-3.5 w-3.5',
                        attributes: {
                          'viewBox': '0 0 20 20',
                          'fill': 'currentColor',
                          'aria-hidden': 'true',
                        },
                        children: [
                          DomComponent(
                            tag: 'path',
                            attributes: {
                              'fill-rule': 'evenodd',
                              'd':
                                  'M3 10a.75.75 0 01.75-.75h10.638L10.23 5.29a.75.75 0 111.04-1.08l5.5 5.25a.75.75 0 010 1.08l-5.5 5.25a.75.75 0 11-1.04-1.08l4.158-3.96H3.75A.75.75 0 013 10z',
                              'clip-rule': 'evenodd',
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
