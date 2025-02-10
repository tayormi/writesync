import 'package:jaspr/jaspr.dart';
import 'package:markdown/markdown.dart' as md;
import '../models/blog_post.dart';

class BlogPostComponent extends StatelessComponent {
  final BlogPost post;

  const BlogPostComponent({
    required this.post,
  });

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield article(classes: 'bg-white', [
      // Hero section with image
      if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
        div(
            classes:
                'relative isolate overflow-hidden bg-gray-900 py-24 sm:py-32',
            [
              img(
                src: post.imageUrl!,
                classes:
                    'absolute inset-0 -z-10 h-full w-full object-cover mix-blend-overlay',
                attributes: {'alt': post.title},
              ),
              div(classes: 'mx-auto max-w-7xl px-6 lg:px-8', [
                div(classes: 'mx-auto max-w-2xl lg:mx-0', [
                  h1(
                      classes:
                          'text-4xl font-bold tracking-tight text-white sm:text-6xl',
                      [
                        text(post.title),
                      ]),
                  p(classes: 'mt-6 text-lg leading-8 text-gray-300', [
                    text(post.description),
                  ]),
                ]),
              ]),
            ])
      else
        div(classes: 'bg-white py-24 sm:py-32', [
          div(classes: 'mx-auto max-w-7xl px-6 lg:px-8', [
            div(classes: 'mx-auto max-w-2xl lg:mx-0', [
              h1(
                  classes:
                      'text-4xl font-bold tracking-tight text-gray-900 sm:text-6xl',
                  [
                    text(post.title),
                  ]),
              p(classes: 'mt-6 text-lg leading-8 text-gray-600', [
                text(post.description),
              ]),
            ]),
          ]),
        ]),

      // Meta information
      div(
          classes:
              'mx-auto max-w-7xl px-6 lg:px-8 py-8 border-b border-gray-200',
          [
            div(
                classes: 'mx-auto max-w-2xl flex items-center justify-between',
                [
                  // Author info
                  div(classes: 'flex items-center gap-x-4', [
                    if (post.authorImageUrl != null &&
                        post.authorImageUrl!.isNotEmpty)
                      img(
                        src: post.authorImageUrl!,
                        classes:
                            'h-10 w-10 rounded-full bg-gray-100 object-cover',
                        attributes: {'alt': post.author},
                      ),
                    div([
                      span(
                          classes: 'text-sm font-medium text-gray-900',
                          [text(post.author)]),
                      div(
                          classes:
                              'flex items-center gap-x-4 text-sm text-gray-500',
                          [
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
                          ]),
                    ]),
                  ]),
                  // Tags
                  div(classes: 'flex flex-wrap gap-2', [
                    for (final tag in post.tags)
                      a(
                        href: '/tags/${tag.toLowerCase()}',
                        classes:
                            'inline-flex items-center rounded-full bg-gray-50 px-3 py-1.5 text-sm font-medium text-gray-600 hover:bg-gray-100',
                        [text(tag)],
                      ),
                  ]),
                ]),
          ]),

      // Content
      div(classes: 'mx-auto max-w-7xl px-6 lg:px-8 py-16', [
        div(
          classes:
              'prose prose-lg prose-indigo mx-auto prose-img:rounded-xl prose-headings:font-semibold prose-a:text-indigo-600 hover:prose-a:text-indigo-500',
          attributes: {
            'innerHTML': md.markdownToHtml(
              post.markdownContent,
              extensionSet: md.ExtensionSet.gitHubWeb,
              blockSyntaxes: [
                md.TableSyntax(),
                md.FencedCodeBlockSyntax(),
              ],
              inlineSyntaxes: [
                md.InlineHtmlSyntax(),
                md.StrikethroughSyntax(),
              ],
            ),
          },
          [],
        ),
      ]),
    ]);
  }
}
