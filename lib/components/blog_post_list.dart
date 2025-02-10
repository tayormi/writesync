import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../models/blog_post.dart';
import '../config/site_config.dart';
import '../providers/theme_provider.dart';

class BlogPostList extends StatelessComponent {
  final BlogPost post;
  @override
  final Key? key;

  const BlogPostList({required this.post, this.key}) : super(key: key);

  @override
  Iterable<Component> build(BuildContext context) sync* {
    final isDark = context.watch(isDarkProvider);

    yield article(
      classes:
          'group bg-white dark:bg-gray-800 rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-shadow duration-300',
      [
        div(
          classes: 'flex flex-col sm:flex-row items-start gap-6 p-6',
          [
            // Featured Image
            if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
              div(
                classes:
                    'w-full sm:w-48 aspect-[4/3] overflow-hidden rounded-lg mb-4 sm:mb-0',
                [
                  img(
                    src: post.imageUrl!,
                    classes:
                        'w-full h-full object-cover transition-transform duration-300 group-hover:scale-105',
                    attributes: {'alt': post.title},
                  ),
                ],
              ),

            // Content
            div(
              classes: 'flex-grow min-w-0',
              [
                // Tags
                div(
                  classes: 'flex flex-wrap gap-2 mb-2',
                  [
                    for (final tag in post.tags)
                      span(
                        classes:
                            'px-2 py-1 text-xs font-medium ${SiteConfig.getPrimaryLightClasses(isDark: isDark)} rounded-full',
                        [text(tag)],
                      ),
                  ],
                ),

                // Title and Description
                h3(
                  classes:
                      'text-xl font-bold mb-2 text-gray-900 dark:text-white group-hover:${SiteConfig.getPrimaryTextClasses(isDark: isDark)} transition-colors duration-300',
                  [
                    a(
                      href: '/blog/${post.slug}',
                      [text(post.title)],
                    ),
                  ],
                ),
                p(
                  classes: 'text-gray-600 dark:text-gray-400 mb-4 line-clamp-2',
                  [text(post.description)],
                ),

                // Metadata
                div(
                  classes:
                      'flex flex-col sm:flex-row items-start sm:items-center justify-between gap-2 sm:gap-0 text-sm text-gray-600 dark:text-gray-400',
                  [
                    // Author and Date
                    div(
                      classes: 'flex items-center gap-4',
                      [
                        // Author
                        div(
                          classes: 'flex items-center gap-2',
                          [
                            if (post.authorImageUrl != null &&
                                post.authorImageUrl!.isNotEmpty)
                              img(
                                src: post.authorImageUrl!,
                                classes: 'h-6 w-6 rounded-full',
                                attributes: {'alt': post.author},
                              ),
                            text(post.author),
                          ],
                        ),
                        // Date
                        DomComponent(
                          tag: 'time',
                          attributes: {
                            'datetime': post.publishedAt.toIso8601String()
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
                    // Read more link
                    a(
                      href: '/blog/${post.slug}',
                      classes:
                          '${SiteConfig.getPrimaryTextClasses(isDark: isDark)} hover:underline',
                      [text('Read more →')],
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
