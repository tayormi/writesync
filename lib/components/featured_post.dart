import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../models/blog_post.dart';
import '../config/site_config.dart';
import '../providers/theme_provider.dart';

class FeaturedPost extends StatelessComponent {
  final BlogPost post;

  const FeaturedPost({required this.post});

  @override
  Component build(BuildContext context) {
    final isDark = context.watch(isDarkProvider);

    return div(
      classes: '',
      [
        // Section header
        div(
          classes: 'flex items-center gap-4 mb-4',
          [
            div(
              classes: 'flex items-center gap-2',
              [
                div(
                  classes: 'w-1 h-5 bg-brand dark:bg-brand-light rounded-full',
                  [],
                ),
                h2(
                  classes: 'text-lg font-bold text-gray-900 dark:text-white',
                  [Component.text('Featured Article')],
                ),
              ],
            ),
            div(
              classes: 'flex-grow h-px bg-gray-200 dark:bg-gray-700',
              [],
            ),
          ],
        ),
        // Featured post card
        a(
          href: '/blog/${post.slug}',
          classes: '''
            group relative isolate flex flex-col lg:flex-row gap-4 
            overflow-hidden bg-white dark:bg-gray-800 rounded-xl 
            border border-gray-100 dark:border-gray-800
            hover:border-gray-200 dark:hover:border-gray-700
            hover:shadow-xl transition-all duration-300 mb-6
          ''',
          [
            // Image section
            div(
              classes:
                  'w-full lg:w-2/5 aspect-[16/9] lg:aspect-[3/2] overflow-hidden',
              [
                if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
                  img(
                    src: post.imageUrl!,
                    classes: '''
                      h-full w-full object-cover 
                      transition-all duration-500 
                      group-hover:scale-105 group-hover:brightness-90
                    ''',
                    attributes: {'alt': post.title},
                  ),
              ],
            ),

            // Content section
            div(
              classes: 'flex flex-col justify-between p-3 lg:p-5 lg:w-3/5',
              [
                div([
                  // Tags
                  if (post.tags.isNotEmpty)
                    div(
                      classes: 'flex flex-wrap gap-2 mb-3',
                      [
                        for (final tag in post.tags)
                          span(
                            classes: '''
                              px-2.5 py-0.5 text-sm font-medium rounded-full
                              ${SiteConfig.getPrimaryLightClasses(isDark: isDark)}
                              transition-colors duration-200
                            ''',
                            [Component.text(tag)],
                          ),
                      ],
                    ),

                  // Title
                  h3(
                    classes: '''
                      text-xl sm:text-2xl font-bold mb-3
                      text-gray-900 dark:text-white 
                      group-hover:text-brand dark:group-hover:text-brand-light
                      transition-colors duration-200 line-clamp-2
                    ''',
                    [Component.text(post.title)],
                  ),

                  // Description
                  p(
                    classes: '''
                      text-base text-gray-600 dark:text-gray-400 
                      mb-4 line-clamp-2
                    ''',
                    [Component.text(post.description)],
                  ),
                ]),
                div([
                  // Author and date section
                  div(
                    classes: 'flex items-center justify-between',
                    [
                      div(
                        classes: 'flex items-center gap-3',
                        [
                          if (post.authorImageUrl != null &&
                              post.authorImageUrl!.isNotEmpty)
                            img(
                              src: post.authorImageUrl!,
                              classes:
                                  'h-2 w-2 rounded-full border-2 border-white dark:border-gray-700',
                              attributes: {'alt': post.author},
                            ),
                          div(
                            classes: 'text-sm',
                            [
                              p(
                                classes: '''
                                  font-semibold text-gray-900 dark:text-white 
                                  group-hover:text-brand dark:group-hover:text-brand-light
                                  transition-colors duration-200
                                ''',
                                [Component.text(post.author)],
                              ),
                              Component.element(
                                tag: 'time',
                                classes:
                                    'text-sm text-gray-500 dark:text-gray-400',
                                attributes: {
                                  'datetime': post.publishedAt.toIso8601String()
                                },
                                children: [
                                  Component.text(post.publishedAt
                                      .toLocal()
                                      .toString()
                                      .split(' ')[0])
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Read more link with arrow
                      span(
                        classes: '''
                          inline-flex items-center text-sm font-medium
                          ${SiteConfig.getPrimaryTextClasses(isDark: isDark)}
                          transition-transform duration-200
                          group-hover:translate-x-1
                        ''',
                        [
                          Component.text('Read article'),
                          Component.element(
                            tag: 'svg',
                            classes: 'ml-1.5 h-4 w-4',
                            attributes: {
                              'viewBox': '0 0 20 20',
                              'fill': 'currentColor',
                            },
                            children: [
                              Component.element(
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
