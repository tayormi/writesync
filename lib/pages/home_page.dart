import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../components/blog_post.dart';
import '../components/featured_post.dart';
import '../components/layout.dart';
import '../components/layout_toggle.dart';
import '../components/pagination.dart';
import '../providers/layout_provider.dart';
import '../providers/pagination_provider.dart';
import '../services/blog_service.dart';
import '../mixins/monitoring_mixin.dart';

class HomePage extends StatefulComponent {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with MonitoringMixin<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    await trackOperation('loadPosts', () async {
      try {
        final blogService = context.read(blogServiceProvider);
        final posts = blogService.getAllPosts();

        trackComponentEvent('posts_loaded', properties: {
          'count': posts.length,
          'success': true,
        });
      } catch (e, stackTrace) {
        trackComponentError(
          'Failed to load posts',
          type: 'LoadError',
          stackTrace: stackTrace,
          properties: {'error': e.toString()},
        );
      }
    });
  }

  @override
  Iterable<Component> build(BuildContext context) sync* {
    final blogService = context.watch(blogServiceProvider);
    final allPosts = blogService.getAllPosts();
    final currentPage = context.watch(currentPageProvider);
    final currentLayout = context.watch(blogLayoutProvider);

    if (allPosts.isEmpty) {
      yield Layout(
        children: [
          div(
            classes: 'container mx-auto px-4 py-8 text-center',
            [
              text(
                  'No blog posts available. Please make sure your markdown files are properly built and registered.'),
            ],
          ),
        ],
      );
      return;
    }

    try {
      // Get featured and regular posts
      final featuredPost = blogService.getFeaturedPost();
      final remainingPosts = blogService.getNonFeaturedPosts();

      // Update pagination state
      context.read(paginationProvider.notifier).updatePagination(
            remainingPosts.length,
            currentPage,
          );

      // Track page state
      trackComponentEvent('page_state_updated', properties: {
        'total_posts': allPosts.length,
        'current_page': currentPage,
        'layout': currentLayout.toString(),
        'featured_post': featuredPost.slug,
      });

      // Calculate pagination for remaining posts
      final startIndex = (currentPage - 1) * postsPerPage;
      final endIndex = startIndex + postsPerPage;
      final paginatedPosts = remainingPosts.length > startIndex
          ? remainingPosts.sublist(
              startIndex,
              endIndex > remainingPosts.length
                  ? remainingPosts.length
                  : endIndex,
            )
          : <dynamic>[];

      yield Layout(
        children: [
          div(
            classes: 'container mx-auto px-4 py-8',
            [
              // Featured post
              div(
                classes: 'mb-12',
                [FeaturedPost(post: featuredPost)],
              ),

              // Latest Posts header with layout toggle
              div(
                classes: 'flex justify-between items-center mb-8',
                [
                  h1(
                    classes: 'text-3xl font-bold text-gray-900 dark:text-white',
                    [text('Latest Posts')],
                  ),
                  const LayoutToggle(),
                ],
              ),

              // Blog posts grid/list
              div(
                classes: currentLayout == BlogLayout.grid
                    ? 'grid gap-8 md:grid-cols-2 lg:grid-cols-3'
                    : 'space-y-8',
                [
                  for (final post in paginatedPosts) BlogPostCard(post: post),
                ],
              ),

              // Pagination
              if (remainingPosts.length > postsPerPage) const Pagination(),
            ],
          ),
        ],
      );
    } catch (e, stackTrace) {
      trackComponentError(
        'Error rendering home page',
        type: 'RenderError',
        stackTrace: stackTrace,
        properties: {'error': e.toString()},
      );

      yield Layout(
        children: [
          div(
            classes: 'container mx-auto px-4 py-8 text-center',
            [
              text('Error: $e'),
            ],
          ),
        ],
      );
    }
  }
}
