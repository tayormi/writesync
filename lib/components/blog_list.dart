import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../models/blog_post.dart';
import '../providers/layout_provider.dart';
import '../components/blog_post.dart';
import '../config/site_config.dart';

class BlogList extends StatelessComponent {
  final List<BlogPost> posts;

  const BlogList({
    required this.posts,
  });

  @override
  Iterable<Component> build(BuildContext context) sync* {
    final currentLayout = context.watch(blogLayoutProvider);
    final isListView = currentLayout == BlogLayout.list;

    yield div(
      classes: 'py-16 sm:py-24',
      [
        div(
          classes: 'mx-auto max-w-7xl px-6 lg:px-8',
          [
            div(
              classes: 'mx-auto max-w-2xl text-center',
              [
                h2(
                  classes:
                      'text-3xl font-bold tracking-tight text-gray-900 dark:text-white sm:text-4xl',
                  [text('Latest Articles')],
                ),
                p(
                  classes:
                      'mt-2 text-lg leading-8 text-gray-600 dark:text-gray-300',
                  [
                    text(
                        'Stay up to date with our latest insights and developments')
                  ],
                ),
              ],
            ),
            div(
              classes: isListView
                  ? 'mx-auto mt-16 max-w-4xl space-y-6 w-full'
                  : 'mx-auto mt-16 grid max-w-2xl auto-rows-fr grid-cols-1 gap-8 sm:mt-20 lg:mx-0 lg:max-w-none lg:grid-cols-3',
              [
                for (final post in posts)
                  if (isListView)
                    BlogPostListCard(post: post)
                  else
                    BlogPostCard(post: post),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class BlogPostListCard extends StatelessComponent {
  final BlogPost post;

  const BlogPostListCard({
    required this.post,
    super.key,
  });

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield article(
      classes: '''
        flex flex-row bg-white dark:bg-gray-800 rounded-lg overflow-hidden
        border border-gray-100 dark:border-gray-800
        hover:border-gray-200 dark:hover:border-gray-700
        hover:shadow-lg transition-all duration-300
        w-full
      ''',
      [
        // Left side - Image
        if (post.imageUrl != null)
          div(
            classes: '''
              w-48 min-w-[12rem] h-48 overflow-hidden
              flex-shrink-0
            ''',
            [
              img(
                src: post.imageUrl!,
                classes: '''
                  w-full h-full object-cover
                  hover:scale-105 transition-transform duration-200
                ''',
                alt: post.title,
              ),
            ],
          ),
        // Right side - Content
        div(
          classes: '''
            flex-1 p-6 flex flex-col justify-between
            min-w-0
          ''',
          [
            div(
              classes: 'flex-1',
              [
                // Tags
                div(
                  classes: 'flex flex-wrap gap-2 mb-2',
                  [
                    for (final tag in post.tags)
                      span(
                        classes: '''
                          text-xs font-medium px-2 py-1 rounded-full
                          bg-gray-100 dark:bg-gray-700
                          text-gray-600 dark:text-gray-300
                        ''',
                        [text('#$tag')],
                      ),
                  ],
                ),
                // Title
                a(
                  href: post.canonicalUrl,
                  classes: '''
                    text-xl font-bold text-gray-900 dark:text-white
                    hover:text-indigo-600 dark:hover:text-indigo-400
                    line-clamp-2 mb-2
                  ''',
                  [text(post.title)],
                ),
                // Description
                p(
                  classes: '''
                    text-gray-600 dark:text-gray-300
                    line-clamp-2 mb-4
                  ''',
                  [text(post.description)],
                ),
              ],
            ),
            // Author and date
            div(
              classes: 'flex items-center',
              [
                if (post.authorImageUrl != null)
                  img(
                    src: post.authorImageUrl ?? SiteConfig.defaultAuthorImage,
                    classes: 'w-10 h-10 rounded-full mr-4',
                    alt: 'Avatar of ${post.author}',
                  ),
                div(
                  classes: 'text-sm',
                  [
                    p(
                      classes: '''
                        font-semibold text-gray-900 dark:text-white
                        hover:text-indigo-600 dark:hover:text-indigo-400
                      ''',
                      [text(post.author)],
                    ),
                    p(
                      classes: 'text-gray-600 dark:text-gray-400',
                      [
                        text(post.publishedAt
                            .toLocal()
                            .toString()
                            .split(' ')[0]),
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
