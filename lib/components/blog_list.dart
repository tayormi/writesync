import 'package:jaspr/jaspr.dart';
import '../models/blog_post.dart';

class BlogList extends StatelessComponent {
  final List<BlogPost> posts;

  const BlogList({
    required this.posts,
  });

  @override
  Iterable<Component> build(BuildContext context) sync* {
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
              classes:
                  'mx-auto mt-16 grid max-w-2xl auto-rows-fr grid-cols-1 gap-8 sm:mt-20 lg:mx-0 lg:max-w-none lg:grid-cols-3',
              [
                for (final post in posts)
                  article(
                    classes:
                        'relative isolate flex flex-col justify-end overflow-hidden rounded-2xl bg-gray-900 px-8 pb-8 pt-80 sm:pt-48 lg:pt-80',
                    [
                      img(
                        src: post.imageUrl ??
                            'https://images.unsplash.com/photo-1496128858413-b36217c2ce36?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=3603&q=80',
                        classes:
                            'absolute inset-0 -z-10 h-full w-full object-cover',
                        attributes: {'alt': post.title},
                      ),
                      div(
                        classes:
                            'absolute inset-0 -z-10 bg-gradient-to-t from-gray-900 via-gray-900/40',
                        [],
                      ),
                      div(
                        classes:
                            'absolute inset-0 -z-10 rounded-2xl ring-1 ring-inset ring-gray-900/10',
                        [],
                      ),
                      div(
                        classes:
                            'flex flex-wrap items-center gap-y-1 overflow-hidden text-sm leading-6 text-gray-300',
                        [
                          DomComponent(
                            tag: 'time',
                            classes: 'mr-8',
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
                          div(
                            classes: 'flex items-center gap-x-4',
                            [
                              div(
                                classes: 'flex items-center gap-x-2',
                                [
                                  if (post.authorImageUrl != null &&
                                      post.authorImageUrl!.isNotEmpty)
                                    img(
                                      src: post.authorImageUrl!,
                                      classes:
                                          'h-6 w-6 rounded-full bg-white/10',
                                      attributes: {'alt': post.author},
                                    ),
                                  text(post.author),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      h3(
                        classes:
                            'mt-3 text-lg font-semibold leading-6 text-white',
                        [
                          a(
                            href: '/blog/${post.slug}',
                            [
                              span(
                                classes: 'absolute inset-0',
                                [],
                              ),
                              text(post.title),
                            ],
                          ),
                        ],
                      ),
                      div(
                        classes: 'flex flex-wrap gap-2 mt-3',
                        [
                          for (final tag in post.tags)
                            span(
                              classes:
                                  'inline-flex items-center rounded-full bg-white/10 px-3 py-1 text-xs font-medium text-white',
                              [text(tag)],
                            ),
                        ],
                      ),
                      p(
                        classes:
                            'mt-2 line-clamp-3 text-sm leading-6 text-gray-300',
                        [text(post.description)],
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
