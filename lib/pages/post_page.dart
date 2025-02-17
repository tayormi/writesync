import 'dart:convert';

import 'package:jaspr/jaspr.dart';
import 'package:writesync/config/site_config.dart';
import '../components/layout.dart';
import '../services/blog_service.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';

class PostPage extends StatelessComponent {
  final String slug;

  const PostPage({required this.slug});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    final blogService = context.read(blogServiceProvider);
    final post = blogService.getPostBySlug(slug);

    if (post == null) {
      yield Layout(children: [
        div(
          classes: 'container mx-auto px-4 py-8',
          [
            h1(classes: 'text-3xl font-bold', [text('Post not found')]),
            p(classes: 'mt-4', [
              text('The post you are looking for does not exist.'),
            ]),
          ],
        ),
      ]);
      return;
    }
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

    yield Layout(children: [
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
                'image': post.authorImageUrl ?? SiteConfig.defaultAuthorImage,
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
      article(
        classes: 'container mx-auto px-4 py-8',
        [
          // Header section with post metadata
          header(
            classes: 'mb-8',
            [
              h1(
                classes:
                    'text-4xl font-bold mb-4 text-gray-900 dark:text-white',
                [text(post.title)],
              ),
              div(
                classes:
                    'flex items-center space-x-4 text-gray-600 dark:text-gray-400',
                [
                  if (post.authorImageUrl != null)
                    img(
                      classes: 'w-10 h-10 rounded-full',
                      src: post.authorImageUrl!,
                      attributes: {'alt': post.author},
                    ),
                  div(
                    classes: 'flex flex-col',
                    [
                      span(classes: 'font-medium', [text(post.author)]),
                      span(classes: 'text-sm', [
                        text(post.publishedAt
                            .toLocal()
                            .toString()
                            .split(' ')[0]),
                      ]),
                    ],
                  ),
                ],
              ),
              div(
                classes: 'flex flex-wrap gap-2 mt-4',
                [
                  for (final tag in post.tags)
                    span(
                      classes:
                          'px-3 py-1 bg-gray-100 dark:bg-gray-800 rounded-full text-sm text-gray-700 dark:text-gray-300',
                      [text('#$tag')],
                    ),
                ],
              ),
              if (post.imageUrl != null)
                div(
                  classes: 'mt-6',
                  [
                    img(
                      classes: 'w-full h-64 object-cover rounded-lg',
                      src: post.imageUrl!,
                      attributes: {'alt': post.title},
                    ),
                  ],
                ),
            ],
          ),
          // Post content
          div(
            classes:
                'prose prose-lg mx-auto dark:prose-invert prose-img:rounded-xl prose-headings:font-semibold',
            _renderContent(post.content),
          ),
        ],
      ),
    ]);
  }

  List<Component> _renderContent(String content) {
    print('Rendering content:');
    print(content);

    // Unescape the content
    content = content
        .replaceAll(r'\n', '\n')
        .replaceAll(r'\r', '')
        .replaceAll(r'\"', '"')
        .replaceAll(r"\'", "'")
        .replaceAll(r'\\', '\\')
        .replaceAll(r'\t', '\t')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&')
        .replaceAll('&#x27;', "'")
        .replaceAll('&#x2F;', '/');

    final blocks = _splitHtmlBlocks(content);
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

    // Split by newlines to separate blocks while preserving code blocks
    final lines = html.split('\n');
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Skip empty paragraphs
      if (line.trim() == '<p></p>') continue;

      // Handle code blocks
      if (line.trim().startsWith('<pre')) {
        if (currentBlock.isNotEmpty) {
          blocks.add(currentBlock);
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
        if (line.trim().endsWith('</pre>')) {
          blocks.add(currentBlock); // Don't trim or modify code blocks
          currentBlock = '';
          inPreBlock = false;
        }
        continue;
      }

      // Handle list-like paragraphs
      if (line.startsWith('<p>-') ||
          line.startsWith('<p>•') ||
          line.startsWith('<p>1.')) {
        if (!inListBlock && currentBlock.isNotEmpty) {
          blocks.add(currentBlock.trim());
          currentBlock = '';
        }
        inListBlock = true;
        listItems.add(line);
        continue;
      }

      // If we were in a list block but this line isn't a list item, add the list and reset
      if (inListBlock &&
          !line.startsWith('<p>-') &&
          !line.startsWith('<p>•') &&
          !line.startsWith('<p>1.')) {
        _addListToBlocks(listItems, blocks);
        inListBlock = false;
        listItems.clear();
      }

      // Handle regular blocks
      if (line.startsWith('<h1') ||
          line.startsWith('<h2') ||
          line.startsWith('<h3') ||
          line.startsWith('<h4') ||
          line.startsWith('<p') ||
          line.startsWith('<ul') ||
          line.startsWith('<ol') ||
          line.startsWith('<blockquote') ||
          line.startsWith('<hr') ||
          line.startsWith('<table')) {
        if (currentBlock.isNotEmpty) {
          blocks.add(currentBlock.trim());
        }
        currentBlock = line;
      } else if (line.isEmpty) {
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

    return blocks.where((block) => block.trim().isNotEmpty).map((block) {
      // Only normalize whitespace for non-code blocks
      if (block.trim().startsWith('<pre')) {
        return block;
      }
      return block.replaceAll(RegExp(r'\s+'), ' ').trim();
    }).toList();
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

    // Handle inline code tags
    if (trimmed.contains('<code>') && !trimmed.startsWith('<pre>')) {
      final parts = trimmed.split(RegExp(r'<code>|</code>'));
      return p(
          classes: 'my-4 leading-relaxed text-gray-600 dark:text-gray-400',
          [
            for (var i = 0; i < parts.length; i++)
              if (i % 2 == 0)
                text(_stripHtmlTags(parts[i]))
              else
                code(
                  classes:
                      'px-1.5 py-0.5 mx-0.5 text-sm font-mono bg-gray-100 dark:bg-gray-800 rounded',
                  [text(_stripHtmlTags(parts[i]))],
                ),
          ]);
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

      // Extract code content while preserving whitespace
      final codeContent = trimmed
          .replaceFirst(
              RegExp(r'<pre><code[^>]*>\n?'), '') // Remove opening tags
          .replaceFirst(RegExp(r'\n?</code></pre>$'), '') // Remove closing tags
          .split('\n') // Split into lines
          .map((line) => _unescapeHtml(line)) // Unescape each line
          .join('\n'); // Rejoin with newlines

      return div(
        classes: 'my-6 overflow-hidden',
        [
          div(
            classes: 'rounded-lg bg-gray-50 dark:bg-gray-800',
            [
              // Header with language badge and copy button
              div(
                classes:
                    'px-4 py-2 border-b border-gray-200 dark:border-gray-700 flex items-center justify-between',
                [
                  // Language badge
                  if (language.isNotEmpty)
                    span(
                      classes:
                          'text-xs font-medium text-gray-600 dark:text-gray-400',
                      [text(language)],
                    )
                  else
                    span(classes: '', []), // Empty span to maintain flex layout

                  // Copy button
                  button(
                    classes:
                        'flex items-center gap-1 px-2 py-1 text-xs font-medium text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white transition-colors',
                    attributes: {
                      'onclick': '''
                        const content = `$codeContent`;
                        navigator.clipboard.writeText(content).then(() => {
                          const btn = this;
                          const originalText = btn.innerHTML;
                          btn.innerHTML = '<svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>Copied!';
                          setTimeout(() => {
                            btn.innerHTML = originalText;
                          }, 2000);
                        });
                      ''',
                    },
                    [
                      // Copy icon
                      DomComponent(
                        tag: 'svg',
                        classes: 'w-4 h-4',
                        attributes: {
                          'fill': 'none',
                          'stroke': 'currentColor',
                          'viewBox': '0 0 24 24',
                        },
                        children: [
                          DomComponent(
                            tag: 'path',
                            attributes: {
                              'd':
                                  'M8 5H6a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2v-1M8 5a2 2 0 002 2h2a2 2 0 002-2M8 5a2 2 0 012-2h2a2 2 0 012 2m0 0h2a2 2 0 012 2v3m2 4H10m0 0l3-3m-3 3l3 3',
                              'stroke-linecap': 'round',
                              'stroke-linejoin': 'round',
                              'stroke-width': '2',
                            },
                          ),
                        ],
                      ),
                      text('Copy'),
                    ],
                  ),
                ],
              ),
              // Code content
              pre(
                classes: 'overflow-x-auto',
                attributes: {
                  'style': '''
                    margin: 0;
                    padding: 1rem;
                    white-space: pre !important;
                    tab-size: 2;
                    -moz-tab-size: 2;
                  ''',
                },
                [
                  code(
                    classes:
                        'text-sm font-mono text-gray-800 dark:text-gray-200',
                    attributes: {
                      'style': '''
                        display: block;
                        white-space: pre !important;
                        word-wrap: normal;
                      ''',
                    },
                    [text(codeContent)],
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    }

    // Handle tables
    if (trimmed.startsWith('<table')) {
      return table(
        classes:
            'min-w-full divide-y divide-gray-200 dark:divide-gray-700 my-6',
        _parseTableContent(trimmed),
      );
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

  String _unescapeHtml(String html) {
    return html
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&')
        .replaceAll('&#x27;', "'")
        .replaceAll('&#x2F;', '/');
  }

  String _stripHtmlTags(String html) {
    return _unescapeHtml(
        html.replaceAll(RegExp(r'<[^>]*>', multiLine: true), ''));
  }
}
