import 'dart:html' show window;
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_blog/config/site_config.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../components/blog_post.dart';
import '../components/blog_post_list.dart';
import '../components/featured_post.dart';
import '../components/layout.dart';
import '../components/layout_toggle.dart';
import '../components/pagination.dart';
import '../components/search_bar.dart';
import '../providers/layout_provider.dart';
import '../providers/pagination_provider.dart';
import '../providers/search_provider.dart';
import '../providers/tag_provider.dart';
import '../services/blog_service.dart';

class HomePage extends StatelessComponent {
  const HomePage();

  @override
  Iterable<Component> build(BuildContext context) sync* {
    final blogServiceAsync = context.watch(blogServiceProvider);
    final searchQuery = context.watch(searchQueryProvider);
    final currentLayout = context.watch(blogLayoutProvider);
    final currentPage = context.watch(currentPageProvider);
    final selectedTag = context.watch(selectedTagProvider);
    final allTags = context.watch(allTagsProvider);

    // Add SEO meta tags
    yield Document.head(
      title: selectedTag != null
          ? 'Posts tagged #$selectedTag - Jaspr Blog'
          : 'Jaspr Blog',
      meta: {
        'description':
            'Thoughts, stories and ideas about programming and technology',
        'keywords': allTags.join(', '),
        'og:title': selectedTag != null
            ? 'Posts tagged #$selectedTag - Jaspr Blog'
            : 'Jaspr Blog',
        'og:description':
            'Thoughts, stories and ideas about programming and technology',
        'og:type': 'website',
        'twitter:card': 'summary_large_image',
        'twitter:title': selectedTag != null
            ? 'Posts tagged #$selectedTag - Jaspr Blog'
            : 'Jaspr Blog',
        'twitter:description':
            'Thoughts, stories and ideas about programming and technology',
      },
    );

    yield Layout(
      children: [
        div(
          classes: 'max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12',
          [
            // Header section
            header(
              classes: 'text-center mb-12',
              [
                h1(
                  classes:
                      'text-4xl font-bold text-gray-900 dark:text-white mb-4',
                  [text('Blog')],
                ),
                p(
                  classes: 'text-xl text-gray-600 dark:text-gray-400',
                  [
                    text(SiteConfig.siteDescription),
                  ],
                ),
              ],
            ),

            // Content area
            blogServiceAsync.when(
              loading: () => div(
                classes: 'flex justify-center items-center py-12',
                [
                  div(
                    classes: 'text-gray-600 dark:text-gray-400',
                    [text('Loading posts...')],
                  ),
                ],
              ),
              error: (error, stack) => div(
                classes: 'text-center py-12 text-red-600 dark:text-red-400',
                [
                  text('Error loading posts: $error'),
                ],
              ),
              data: (blogService) {
                // Get posts and filter by tag if selected
                var allPosts = blogService.searchPosts(searchQuery);
                if (selectedTag != null) {
                  allPosts = allPosts
                      .where((post) => post.tags.contains(selectedTag))
                      .toList();
                }

                if (allPosts.isEmpty) {
                  return div(
                    classes:
                        'text-center py-12 text-gray-600 dark:text-gray-400',
                    [
                      text(searchQuery.isEmpty
                          ? selectedTag != null
                              ? 'No posts found with tag #$selectedTag.'
                              : 'No posts found.'
                          : 'No posts found matching "$searchQuery"'),
                    ],
                  );
                }

                // Featured post (only show if no search query and on first page)
                final showFeatured = searchQuery.isEmpty && currentPage == 1;
                final featuredPost = showFeatured ? allPosts.first : null;
                final remainingPosts =
                    showFeatured ? allPosts.skip(1).toList() : allPosts;

                // Calculate total pages based on remaining posts
                final totalPages =
                    ((remainingPosts.length + postsPerPage - 1) / postsPerPage)
                        .ceil();

                // Ensure current page is within valid range
                var adjustedCurrentPage = currentPage;
                if (adjustedCurrentPage > totalPages) {
                  adjustedCurrentPage = totalPages;
                  context.read(currentPageProvider.notifier).state =
                      adjustedCurrentPage;
                }

                // Update pagination state
                context.read(paginationProvider.notifier).updatePagination(
                      remainingPosts.length,
                      adjustedCurrentPage,
                    );

                // Calculate paginated posts
                final startIndex = (adjustedCurrentPage - 1) * postsPerPage;
                final endIndex = startIndex + postsPerPage;
                final displayPosts = remainingPosts.sublist(
                  startIndex.clamp(0, remainingPosts.length),
                  endIndex.clamp(0, remainingPosts.length),
                );

                // Calculate total pages correctly
                final effectivePostsPerPage =
                    postsPerPage - (showFeatured ? 1 : 0);
                final totalPagesCorrect =
                    ((remainingPosts.length + effectivePostsPerPage - 1) /
                            effectivePostsPerPage)
                        .ceil();

                print('Total posts: ${allPosts.length}');
                print('Remaining posts: ${remainingPosts.length}');
                print('Current page: $adjustedCurrentPage');
                print('Start index: $startIndex');
                print('End index: $endIndex');
                print('Display posts: ${displayPosts.length}');
                print('Effective posts per page: $effectivePostsPerPage');

                return div([
                  // Featured post
                  if (featuredPost != null) FeaturedPost(post: featuredPost),

                  // Recent Articles header
                  div(
                    classes: 'flex items-center gap-2 mt-12 mb-8',
                    [
                      h2(
                        classes:
                            'text-lg font-semibold text-gray-900 dark:text-white',
                        [text('Recent Articles')],
                      ),
                      div(
                        classes: 'flex-grow h-px bg-gray-200 dark:bg-gray-700',
                        [],
                      ),
                    ],
                  ),

                  // Search and layout controls
                  div(
                    classes:
                        'flex flex-col sm:flex-row items-center justify-between gap-4 mb-8',
                    [
                      div(
                        classes: 'w-full sm:flex-grow sm:max-w-lg',
                        [const SearchBar()],
                      ),
                      div(
                        classes: 'hidden sm:block',
                        [const LayoutToggle()],
                      ),
                    ],
                  ),

                  // Posts grid/list - force list on mobile
                  if (currentLayout == BlogLayout.grid &&
                      (window.innerWidth ?? 0) > 640)
                    div(
                      classes: 'grid gap-8 md:grid-cols-2 lg:grid-cols-3',
                      [
                        for (final post in displayPosts)
                          BlogPostCard(
                            post: post,
                            key: Key('post-${post.slug}'),
                          ),
                      ],
                    )
                  else
                    div(
                      classes: 'space-y-8',
                      [
                        for (final post in displayPosts)
                          BlogPostList(
                            post: post,
                            key: Key('post-${post.slug}'),
                          ),
                      ],
                    ),

                  // Pagination
                  if (totalPagesCorrect > 1) const Pagination(),
                ]);
              },
            ),
          ],
        ),
      ],
    );
  }
}
