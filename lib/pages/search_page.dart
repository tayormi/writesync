import 'dart:html';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../components/blog_post.dart';
import '../components/layout.dart';
import '../components/tag_chip.dart';
import '../providers/tag_provider.dart';
import '../services/blog_service.dart';

class SearchPage extends StatefulComponent {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = '';
  String? selectedAuthor;
  String? selectedYear;
  String? selectedMonth;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    final blogService = context.watch(blogServiceProvider);
    final selectedTag = context.watch(selectedTagProvider);

    var allPosts = blogService.getAllPosts();

    // Apply filters
    if (searchQuery.isNotEmpty) {
      allPosts = blogService.searchPosts(searchQuery);
    }
    if (selectedTag != null) {
      allPosts = blogService.getPostsByTag(selectedTag);
    }
    if (selectedAuthor != null) {
      allPosts = blogService.getPostsByAuthor(selectedAuthor!);
    }
    if (selectedYear != null) {
      allPosts = blogService.getPostsByYear(selectedYear!);
      if (selectedMonth != null) {
        allPosts = blogService.getPostsByMonth('$selectedYear-$selectedMonth');
      }
    }

    yield Layout(children: [
      div(
        classes: 'container mx-auto px-4 py-8',
        [
          // Header
          div(
            classes: 'mb-8 text-center',
            [
              h1(
                classes:
                    'text-3xl font-bold text-gray-900 dark:text-white mb-4',
                [text('Search Blog Posts')],
              ),
              p(
                classes: 'text-gray-600 dark:text-gray-400',
                [
                  text(
                    'Search through all blog posts using keywords, tags, authors, or dates.',
                  ),
                ],
              ),
            ],
          ),

          // Search and Filters Container
          div(
            classes: 'bg-white dark:bg-gray-800 rounded-lg shadow-lg p-6 mb-8',
            [
              // Search bar
              div(
                classes: 'mb-6',
                [
                  input(
                    [],
                    classes:
                        'w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand focus:border-transparent dark:bg-gray-700 dark:border-gray-600 dark:text-white text-lg',
                    attributes: {
                      'type': 'text',
                      'placeholder':
                          'Search posts by title, content, or description...',
                      'value': searchQuery,
                    },
                    events: {
                      'input': (event) {
                        final target = event.target as InputElement;
                        setState(() {
                          searchQuery = target.value ?? '';
                        });
                      },
                    },
                  ),
                ],
              ),

              // Filter section
              div(
                classes: 'grid grid-cols-1 md:grid-cols-3 gap-6',
                [
                  // Authors filter
                  div(
                    classes: 'flex flex-col gap-2',
                    [
                      text('Filter by Author'),
                      select(
                        classes:
                            'px-4 py-2 border border-gray-300 rounded-lg dark:bg-gray-700 dark:border-gray-600 dark:text-white',
                        events: {
                          'change': (event) {
                            final target = event.target as SelectElement;
                            setState(() {
                              selectedAuthor =
                                  target.value == 'all' ? null : target.value;
                            });
                          },
                        },
                        [
                          option(
                            attributes: {'value': 'all'},
                            [text('All Authors')],
                          ),
                          for (final author in blogService.getAllAuthors())
                            option(
                              attributes: {'value': author},
                              [text(author)],
                            ),
                        ],
                      ),
                    ],
                  ),

                  // Year filter
                  div(
                    classes: 'flex flex-col gap-2',
                    [
                      text('Filter by Year'),
                      select(
                        classes:
                            'px-4 py-2 border border-gray-300 rounded-lg dark:bg-gray-700 dark:border-gray-600 dark:text-white',
                        events: {
                          'change': (event) {
                            final target = event.target as SelectElement;
                            setState(() {
                              selectedYear =
                                  target.value == 'all' ? null : target.value;
                              selectedMonth = null;
                            });
                          },
                        },
                        [
                          option(
                            attributes: {'value': 'all'},
                            [text('All Years')],
                          ),
                          for (final year in blogService.getAllYears())
                            option(
                              attributes: {'value': year},
                              [text(year)],
                            ),
                        ],
                      ),
                    ],
                  ),

                  // Month filter
                  if (selectedYear != null)
                    div(
                      classes: 'flex flex-col gap-2',
                      [
                        text('Filter by Month'),
                        select(
                          classes:
                              'px-4 py-2 border border-gray-300 rounded-lg dark:bg-gray-700 dark:border-gray-600 dark:text-white',
                          events: {
                            'change': (event) {
                              final target = event.target as SelectElement;
                              setState(() {
                                selectedMonth =
                                    target.value == 'all' ? null : target.value;
                              });
                            },
                          },
                          [
                            option(
                              attributes: {'value': 'all'},
                              [text('All Months')],
                            ),
                            for (final month in blogService
                                .getAllMonths()
                                .where((m) => m.startsWith(selectedYear!)))
                              option(
                                attributes: {'value': month.split('-')[1]},
                                [
                                  text(_getMonthName(
                                    int.parse(month.split('-')[1]),
                                  )),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),

              // Tags section
              div(
                classes: 'mt-6',
                [
                  p(
                    classes: 'mb-2 text-gray-700 dark:text-gray-300',
                    [text('Filter by Tags')],
                  ),
                  div(
                    classes: 'flex flex-wrap gap-2',
                    [
                      for (final tag in blogService.getAllTags())
                        TagChip(
                          tag: tag,
                          isSelected: tag == selectedTag,
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Results count
          div(
            classes: 'mb-6 text-gray-600 dark:text-gray-400',
            [
              text('${allPosts.length} posts found'),
            ],
          ),

          // Results grid
          if (allPosts.isEmpty)
            div(
              classes: 'text-center py-12 text-gray-600 dark:text-gray-400',
              [
                text('No posts found matching your criteria.'),
              ],
            )
          else
            div(
              classes: 'grid gap-8 md:grid-cols-2 lg:grid-cols-3',
              [
                for (final post in allPosts) BlogPostCard(post: post),
              ],
            ),
        ],
      ),
    ]);
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
