import 'dart:convert';
import 'package:jaspr/jaspr.dart';
import 'package:markdown/markdown.dart' as md;
import '../components/layout.dart';
import '../services/blog_service.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../config/site_config.dart';

class PostPage extends StatelessComponent {
  final String slug;

  const PostPage({required this.slug});

  List<Component> _renderMarkdown(String content) {
    print('Rendering markdown content:');
    print(content);
    final html = md.markdownToHtml(
      content,
      extensionSet: md.ExtensionSet.gitHubWeb,
      blockSyntaxes: [
        md.TableSyntax(),
        md.FencedCodeBlockSyntax(),
        md.HeaderSyntax(),
        md.BlockquoteSyntax(),
        md.HorizontalRuleSyntax(),
        md.ParagraphSyntax(),
        md.SetextHeaderSyntax(),
        md.HeaderWithIdSyntax(),
        md.OrderedListSyntax(),
        md.UnorderedListSyntax(),
      ],
      inlineSyntaxes: [
        md.InlineHtmlSyntax(),
        md.StrikethroughSyntax(),
        md.AutolinkSyntax(),
        md.LineBreakSyntax(),
        md.EmojiSyntax(),
        md.CodeSyntax(),
        md.LinkSyntax(),
        md.ImageSyntax(),
      ],
    );

    print('Generated HTML:');
    print(html);
    final blocks = _splitHtmlBlocks(html);
    print('Split blocks:');
    for (var block in blocks) {
      print('Block: $block');
    }
    final components = blocks
        .map((block) {
          final component = _convertHtmlBlockToComponent(block);
          print('Converted block to component: ${component?.runtimeType}');
          return component;
        })
        .whereType<Component>()
        .toList();
    print('Generated ${components.length} components');
    return components;
  }

  List<String> _splitHtmlBlocks(String html) {
    final blocks = <String>[];
    var currentBlock = '';
    var inPreBlock = false;
    var inListBlock = false;
    var listItems = <String>[];

    // Split by double newlines to separate blocks while preserving code blocks
    final lines = html.split('\n');
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmedLine = line.trim();

      // Skip empty paragraphs
      if (trimmedLine == '<p></p>') continue;

      // Handle code blocks
      if (trimmedLine.startsWith('<pre')) {
        if (currentBlock.isNotEmpty) {
          blocks.add(currentBlock.trim());
          currentBlock = '';
        }
        if (inListBlock) {
          _addListToBlocks(listItems, blocks);
          inListBlock = false;
          listItems.clear();
        }
        inPreBlock = true;
        currentBlock = line;
        continue;
      }

      if (inPreBlock) {
        currentBlock += '\n$line';
        if (trimmedLine.endsWith('</pre>')) {
          blocks.add(currentBlock.trim());
          currentBlock = '';
          inPreBlock = false;
        }
        continue;
      }

      // Handle list-like paragraphs
      if (trimmedLine.startsWith('<p>-') ||
          trimmedLine.startsWith('<p>•') ||
          trimmedLine.startsWith('<p>1.')) {
        if (!inListBlock && currentBlock.isNotEmpty) {
          blocks.add(currentBlock.trim());
          currentBlock = '';
        }
        inListBlock = true;
        listItems.add(trimmedLine);
        continue;
      }

      // If we were in a list block but this line isn't a list item, add the list and reset
      if (inListBlock &&
          !trimmedLine.startsWith('<p>-') &&
          !trimmedLine.startsWith('<p>•') &&
          !trimmedLine.startsWith('<p>1.')) {
        _addListToBlocks(listItems, blocks);
        inListBlock = false;
        listItems.clear();
      }

      // Handle regular blocks
      if (trimmedLine.startsWith('<h1') ||
          trimmedLine.startsWith('<h2') ||
          trimmedLine.startsWith('<h3') ||
          trimmedLine.startsWith('<h4') ||
          trimmedLine.startsWith('<p') ||
          trimmedLine.startsWith('<ul') ||
          trimmedLine.startsWith('<ol') ||
          trimmedLine.startsWith('<blockquote') ||
          trimmedLine.startsWith('<hr') ||
          trimmedLine.startsWith('<table')) {
        if (currentBlock.isNotEmpty) {
          blocks.add(currentBlock.trim());
          currentBlock = '';
        }
        currentBlock = line;
      } else if (trimmedLine.isEmpty) {
        if (currentBlock.isNotEmpty) {
          blocks.add(currentBlock.trim());
          currentBlock = '';
        }
      } else {
        if (currentBlock.isEmpty) {
          currentBlock = line;
        } else {
          currentBlock += '\n$line';
        }
      }
    }

    // Handle any remaining content
    if (inListBlock) {
      _addListToBlocks(listItems, blocks);
    } else if (currentBlock.isNotEmpty) {
      blocks.add(currentBlock.trim());
    }

    return blocks.where((block) => block.trim().isNotEmpty).toList();
  }

  void _addListToBlocks(List<String> items, List<String> blocks) {
    if (items.isEmpty) return;

    // Check if it's a numbered list
    final isNumbered = items.first.contains('<p>1.');

    final listTag = isNumbered ? 'ol' : 'ul';
    final listItems = items.map((item) {
      final content = item
          .replaceAll('<p>', '')
          .replaceAll('</p>', '')
          .replaceFirst(RegExp(r'^[-•]|\d+\.'), '')
          .trim();
      return '<li>$content</li>';
    }).join('\n');

    blocks.add('<$listTag>\n$listItems\n</$listTag>');
  }

  Component? _convertHtmlBlockToComponent(String block) {
    final trimmed = block.trim();
    if (trimmed.isEmpty || trimmed == '<p></p>') return null;

    // Handle images
    if (trimmed.startsWith('<p><img')) {
      final imgMatch =
          RegExp(r'<img[^>]+src="([^"]+)"[^>]*>').firstMatch(trimmed);
      final altMatch = RegExp(r'alt="([^"]+)"').firstMatch(trimmed);
      final widthMatch = RegExp(r'width="([^"]+)"').firstMatch(trimmed);

      if (imgMatch != null) {
        final src = imgMatch.group(1) ?? '';
        final alt = altMatch?.group(1) ?? '';
        final width = widthMatch?.group(1);

        // Check if there's a caption (em tag after image)
        final captionMatch = RegExp(r'<em>(.*?)</em>').firstMatch(trimmed);
        final caption = captionMatch?.group(1);

        return div(classes: 'my-8', [
          img(
            src: src,
            classes:
                'rounded-lg w-full object-cover${width != null ? ' max-w-[$width]px' : ''}',
            attributes: {'alt': alt},
          ),
          if (caption != null)
            p(classes: 'mt-2 text-center text-sm text-gray-500 italic', [
              text(caption),
            ]),
        ]);
      }
    }

    // Handle iframes (videos)
    if (trimmed.startsWith('<p><iframe')) {
      final srcMatch = RegExp(r'src="([^"]+)"').firstMatch(trimmed);
      final widthMatch = RegExp(r'width="([^"]+)"').firstMatch(trimmed);
      final heightMatch = RegExp(r'height="([^"]+)"').firstMatch(trimmed);

      if (srcMatch != null) {
        final src = srcMatch.group(1) ?? '';
        final width = widthMatch?.group(1) ?? '560';
        final height = heightMatch?.group(1) ?? '315';

        return div(classes: 'my-8 relative aspect-video', [
          DomComponent(
            tag: 'iframe',
            attributes: {
              'src': src,
              'width': width,
              'height': height,
              'frameborder': '0',
              'allowfullscreen': 'true',
              'style':
                  'position: absolute; top: 0; left: 0; width: 100%; height: 100%;',
            },
          ),
        ]);
      }
    }

    // Handle HTML elements with style attributes
    if (trimmed.startsWith('<div style=')) {
      final styleMatch = RegExp(r'style="([^"]+)"').firstMatch(trimmed);
      final contentMatch =
          RegExp(r'<div[^>]*>(.*?)</div>', dotAll: true).firstMatch(trimmed);

      if (contentMatch != null && styleMatch != null) {
        final content = contentMatch.group(1) ?? '';
        final style = styleMatch.group(1) ?? '';
        return div(
          attributes: {'style': style},
          [text(content)],
        );
      }
    }

    // Handle details/summary elements
    if (trimmed.startsWith('<details>')) {
      final summaryMatch =
          RegExp(r'<summary>(.*?)</summary>').firstMatch(trimmed);
      final contentMatch = RegExp(r'</summary>(.*?)</details>', dotAll: true)
          .firstMatch(trimmed);

      if (summaryMatch != null && contentMatch != null) {
        return details([
          summary([text(_stripHtmlTags(summaryMatch.group(1) ?? ''))]),
          p(
              classes: 'p-4',
              [text(_stripHtmlTags(contentMatch.group(1) ?? ''))]),
        ]);
      }
    }

    // Handle keyboard shortcuts
    if (trimmed.contains('<kbd>')) {
      final parts = trimmed.split(RegExp(r'<kbd>|</kbd>'));
      return p(classes: 'my-4', [
        for (var i = 0; i < parts.length; i++)
          if (i % 2 == 0)
            text(parts[i])
          else
            DomComponent(
              tag: 'kbd',
              classes:
                  'px-2 py-1.5 text-xs font-semibold text-gray-800 bg-gray-100 border border-gray-200 rounded-lg',
              children: [text(parts[i])],
            ),
      ]);
    }

    // Handle abbreviations
    if (trimmed.contains('<abbr')) {
      final abbrMatch =
          RegExp(r'<abbr title="([^"]+)">(.*?)</abbr>').firstMatch(trimmed);
      if (abbrMatch != null) {
        final title = abbrMatch.group(1) ?? '';
        final content = abbrMatch.group(2) ?? '';
        return p(classes: 'my-4', [
          DomComponent(
            tag: 'abbr',
            attributes: {'title': title},
            children: [text(content)],
          ),
        ]);
      }
    }

    // Handle headings
    if (trimmed.startsWith('<h1')) {
      return h1(
          classes: 'text-2xl font-bold mt-8 mb-4 text-gray-900 dark:text-white',
          [
            text(_stripHtmlTags(trimmed)),
          ]);
    }
    if (trimmed.startsWith('<h2')) {
      return h2(
          classes: 'text-xl font-bold mt-8 mb-4 text-gray-900 dark:text-white',
          [
            text(_stripHtmlTags(trimmed)),
          ]);
    }
    if (trimmed.startsWith('<h3')) {
      return h3(
          classes: 'text-lg font-bold mt-6 mb-3 text-gray-900 dark:text-white',
          [
            text(_stripHtmlTags(trimmed)),
          ]);
    }
    if (trimmed.startsWith('<h4')) {
      return h4(
          classes:
              'text-base font-bold mt-6 mb-3 text-gray-900 dark:text-white',
          [
            text(_stripHtmlTags(trimmed)),
          ]);
    }

    // Handle blockquotes
    if (trimmed.startsWith('<blockquote')) {
      return blockquote(
          classes:
              'pl-4 my-6 border-l-2 border-gray-200 dark:border-gray-700 italic text-gray-600 dark:text-gray-400',
          [text(_stripHtmlTags(trimmed))]);
    }

    // Handle horizontal rules
    if (trimmed == '<hr />') {
      return hr(classes: 'my-8 border-t border-gray-100 dark:border-gray-800');
    }

    // Handle lists
    if (trimmed.startsWith('<ul') || trimmed.startsWith('<ol')) {
      final items = RegExp(r'<li[^>]*>(.*?)</li>', dotAll: true)
          .allMatches(trimmed)
          .map((m) => m.group(1) ?? '')
          .toList();

      final listClasses =
          'pl-5 my-6 space-y-2 text-gray-600 dark:text-gray-400';

      if (trimmed.startsWith('<ul')) {
        return ul(classes: 'list-disc $listClasses', [
          for (final item in items)
            li(classes: 'pl-2', [text(_stripHtmlTags(item))]),
        ]);
      } else {
        return ol(classes: 'list-decimal $listClasses', [
          for (final item in items)
            li(classes: 'pl-2', [text(_stripHtmlTags(item))]),
        ]);
      }
    }

    // Handle code blocks
    if (trimmed.startsWith('<pre><code')) {
      final languageMatch =
          RegExp(r'class="language-([^"]+)"').firstMatch(trimmed);
      final language = languageMatch?.group(1) ?? '';
      final codeContent = trimmed
          .replaceAll(RegExp(r'<pre><code[^>]*>', multiLine: true), '')
          .replaceAll('</code></pre>', '')
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .replaceAll('&quot;', '"')
          .replaceAll('&amp;', '&');

      return div(classes: 'my-6', [
        div(
          classes: 'rounded-lg bg-gray-50 dark:bg-gray-800',
          [
            // Language badge
            if (language.isNotEmpty)
              div(
                classes:
                    'px-4 py-2 border-b border-gray-200 dark:border-gray-700',
                [
                  span(
                    classes:
                        'text-xs font-medium text-gray-600 dark:text-gray-400',
                    [text(language)],
                  ),
                ],
              ),
            // Code content
            pre(
              classes: 'p-4 overflow-x-auto',
              [
                code(
                  classes: 'text-sm font-mono text-gray-800 dark:text-gray-200',
                  [text(codeContent)],
                ),
              ],
            ),
          ],
        ),
      ]);
    }

    // Handle paragraphs and other content
    return p(classes: 'my-4 leading-relaxed text-gray-600 dark:text-gray-400', [
      text(_stripHtmlTags(trimmed)),
    ]);
  }

  List<Component> _parseTableContent(String tableHtml) {
    final components = <Component>[];

    // Extract header
    final headerMatch =
        RegExp(r'<thead>(.*?)</thead>', dotAll: true).firstMatch(tableHtml);
    if (headerMatch != null) {
      final headerContent = headerMatch.group(1) ?? '';
      final headerCells = RegExp(r'<th[^>]*>(.*?)</th>', dotAll: true)
          .allMatches(headerContent)
          .map((m) => m.group(1) ?? '')
          .toList();

      components.add(
        thead([
          tr([
            for (final cell in headerCells)
              th(
                  classes:
                      'px-4 py-2 text-left text-sm font-medium text-gray-900 dark:text-white',
                  [
                    text(_stripHtmlTags(cell)),
                  ]),
          ]),
        ]),
      );
    }

    // Extract body
    final bodyMatch =
        RegExp(r'<tbody>(.*?)</tbody>', dotAll: true).firstMatch(tableHtml);
    if (bodyMatch != null) {
      final bodyContent = bodyMatch.group(1) ?? '';
      final rows =
          RegExp(r'<tr>(.*?)</tr>', dotAll: true).allMatches(bodyContent);

      components.add(
        tbody([
          for (final row in rows)
            tr([
              for (final cell in RegExp(r'<td[^>]*>(.*?)</td>', dotAll: true)
                  .allMatches(row.group(1) ?? ''))
                td(
                    classes:
                        'px-4 py-2 text-sm text-gray-600 dark:text-gray-400 border-t border-gray-100 dark:border-gray-800',
                    [
                      text(_stripHtmlTags(cell.group(1) ?? '')),
                    ]),
            ]),
        ]),
      );
    }

    return components;
  }

  String _stripHtmlTags(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>', multiLine: true), '')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&')
        .replaceAll('&#x27;', "'")
        .replaceAll('&#x2F;', '/');
  }

  @override
  Iterable<Component> build(BuildContext context) sync* {
    final blogServiceAsync = context.watch(blogServiceProvider);

    yield* blogServiceAsync.when(
      loading: () sync* {
        yield Layout(
          children: [
            div(
              classes: 'flex justify-center items-center py-16',
              [
                div(
                  classes: 'text-gray-600 dark:text-gray-400',
                  [text('Loading post...')],
                ),
              ],
            ),
          ],
        );
      },
      error: (error, stack) sync* {
        yield Layout(
          children: [
            div(
              classes: 'flex flex-col items-center justify-center py-16',
              [
                div(
                  classes: 'text-center space-y-4 px-4',
                  [
                    h1(
                      classes:
                          'text-4xl font-bold text-red-600 dark:text-red-400',
                      [text('Error')],
                    ),
                    p(
                      classes: 'text-gray-600 dark:text-gray-400',
                      [text('Error loading post: $error')],
                    ),
                    a(
                      href: '/',
                      classes:
                          'inline-block mt-4 text-indigo-600 hover:text-indigo-700 dark:text-indigo-400 dark:hover:text-indigo-300',
                      [text('← Back to home')],
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
      data: (blogService) sync* {
        final post = blogService.getPostBySlug(slug);

        if (post == null) {
          yield Layout(
            children: [
              div(
                classes: 'flex flex-col items-center justify-center py-16',
                [
                  div(
                    classes: 'text-center space-y-4 px-4',
                    [
                      h1(
                        classes:
                            'text-4xl font-bold text-gray-900 dark:text-white',
                        [text('404')],
                      ),
                      p(
                        classes: 'text-gray-600 dark:text-gray-400',
                        [text('Post not found')],
                      ),
                      a(
                        href: '/',
                        classes:
                            'inline-block mt-4 text-indigo-600 hover:text-indigo-700 dark:text-indigo-400 dark:hover:text-indigo-300',
                        [text('← Back to home')],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
          return;
        }

        // Add SEO meta tags for the blog post
        yield Document.head(
          title: '${post.title} - ${SiteConfig.siteName}',
          meta: {
            'description': post.metaDescription,
            'author': post.author,
            'keywords': post.tags.join(', '),
            'og:title': post.title,
            'og:description': post.metaDescription,
            'og:type': 'article',
            'og:image': post.imageUrl ?? SiteConfig.defaultPostImage,
            'twitter:card': 'summary_large_image',
            'twitter:title': post.title,
            'twitter:description': post.metaDescription,
            'twitter:image': post.imageUrl ?? SiteConfig.defaultPostImage,
            'article:published_time': post.publishedAt.toIso8601String(),
            'article:author': post.author,
            'article:tag': post.tags.join(','),
          },
        );

        yield Layout(
          children: [
            // Add JSON-LD structured data
            div(classes: 'hidden', [
              div(
                attributes: {'type': 'application/ld+json'},
                [
                  text(jsonEncode({
                    '@context': 'https://schema.org',
                    '@type': 'BlogPosting',
                    'headline': post.title,
                    'description': post.metaDescription,
                    'image': post.imageUrl ?? SiteConfig.defaultPostImage,
                    'author': {
                      '@type': 'Person',
                      'name': post.author,
                      'image':
                          post.authorImageUrl ?? SiteConfig.defaultAuthorImage,
                    },
                    'datePublished': post.publishedAt.toIso8601String(),
                    'keywords': post.tags.join(','),
                    'publisher': {
                      '@type': 'Organization',
                      'name': SiteConfig.siteName,
                      'logo': {
                        '@type': 'ImageObject',
                        'url': SiteConfig.siteLogo,
                      },
                    },
                  }))
                ],
              )
            ]),

            // Post content
            div(
              classes: 'w-full max-w-3xl mx-auto px-4 py-16',
              [
                article(
                  classes: 'prose prose-lg mx-auto dark:prose-invert',
                  [
                    // Article Header
                    header(
                      classes: 'mb-12',
                      [
                        // Tags
                        if (SiteConfig.blogDisplay['showTags']! &&
                            post.tags.isNotEmpty)
                          div(
                            classes: 'flex flex-wrap gap-2 mb-4',
                            [
                              for (final tag in post.tags)
                                span(
                                  classes:
                                      'text-sm text-indigo-600 dark:text-indigo-400',
                                  [text(tag)],
                                ),
                            ],
                          ),
                        h1(
                          classes:
                              'text-3xl sm:text-4xl font-bold mb-4 text-gray-900 dark:text-white',
                          [text(post.title)],
                        ),
                        // Author and Date
                        if (SiteConfig.blogDisplay['showAuthor']! ||
                            SiteConfig.blogDisplay['showDate']!)
                          div(
                            classes:
                                'flex items-center gap-4 text-sm text-gray-600 dark:text-gray-400',
                            [
                              // Publication date
                              if (SiteConfig.blogDisplay['showDate']!)
                                DomComponent(
                                  tag: 'time',
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
                              // Author
                              if (SiteConfig.blogDisplay['showAuthor']!)
                                div(
                                  classes: 'flex items-center gap-2',
                                  [
                                    if (SiteConfig
                                            .blogDisplay['showAuthorImage']! &&
                                        post.authorImageUrl != null &&
                                        post.authorImageUrl!.isNotEmpty)
                                      img(
                                        src: post.authorImageUrl!,
                                        classes: 'h-6 w-6 rounded-full',
                                        attributes: {'alt': post.author},
                                      ),
                                    text(post.author),
                                  ],
                                ),
                            ],
                          ),
                      ],
                    ),
                    // Featured Image
                    if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
                      div(
                        classes: 'my-8 -mx-4 sm:-mx-6 md:-mx-8',
                        [
                          img(
                            src: post.imageUrl!,
                            classes: 'w-full rounded-lg',
                            attributes: {'alt': post.title},
                          ),
                        ],
                      ),
                    // Article Content
                    div(
                      classes: 'mt-8',
                      [
                        ..._renderMarkdown(post.content),
                      ],
                    ),
                  ],
                ),
                // Navigation
                nav(
                  classes:
                      'mt-16 pt-8 border-t border-gray-200 dark:border-gray-800',
                  [
                    a(
                      href: '/blog',
                      classes:
                          'inline-flex items-center text-indigo-600 hover:text-indigo-700 dark:text-indigo-400 dark:hover:text-indigo-300',
                      [
                        text('← Back to blog'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
