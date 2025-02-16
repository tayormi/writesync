import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../models/blog_post.dart';
import '../config/site_config.dart';
import '../services/taxonomy_service.dart';

final blogServiceProvider =
    Provider<BlogService>((ref) => BlogService.instance);

class BlogService {
  static final BlogService instance = BlogService._();
  BlogService._();

  final List<BlogPost> _posts = [];
  final _taxonomyService = TaxonomyService.instance;

  Future<void> initialize() async {
    print('Initializing BlogService...');
    try {
      // Initialize any required resources
      // In the future, we can add any async initialization here
      await _initializeBlogPosts();
      print('Blog posts initialized successfully.');
      print('Total posts registered: ${_posts.length}');
      if (_posts.isEmpty) {
        print('Warning: No blog posts were registered!');
      } else {
        print('Registered posts:');
        for (final post in _posts) {
          print('- ${post.title} (${post.slug})');
        }
      }
    } catch (e, stackTrace) {
      print('Error initializing blog posts: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Future<void> _initializeBlogPosts() async {
    // The registration will be handled by the generated code
  }

  void registerPost(BlogPost post) {
    print('Registering post: ${post.title} (${post.slug})');
    _posts.add(post);
    _taxonomyService.indexPost(post);
    // Sort posts by date, newest first
    _posts.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
  }

  List<BlogPost> getAllPosts() {
    return List.unmodifiable(_posts);
  }

  List<BlogPost> getPostsByTag(String tag) {
    return _taxonomyService.getPostsByTag(tag);
  }

  List<BlogPost> getPostsByAuthor(String author) {
    return _taxonomyService.getPostsByAuthor(author);
  }

  List<BlogPost> getPostsByYear(String year) {
    return _taxonomyService.getPostsByYear(year);
  }

  List<BlogPost> getPostsByMonth(String month) {
    return _taxonomyService.getPostsByMonth(month);
  }

  List<BlogPost> searchPosts(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _posts
        .where((post) =>
            post.title.toLowerCase().contains(lowercaseQuery) ||
            post.description.toLowerCase().contains(lowercaseQuery) ||
            post.content.toLowerCase().contains(lowercaseQuery))
        .toList();
  }

  List<String> getAllTags() {
    return _taxonomyService.getAllTags();
  }

  List<String> getAllAuthors() {
    return _taxonomyService.getAllAuthors();
  }

  List<String> getAllYears() {
    return _taxonomyService.getAllYears();
  }

  List<String> getAllMonths() {
    return _taxonomyService.getAllMonths();
  }

  Map<String, int> getTagCounts() {
    return _taxonomyService.getTagCounts();
  }

  BlogPost? getPostBySlug(String slug) {
    try {
      return _posts.firstWhere((post) => post.slug == slug);
    } on StateError {
      return null;
    }
  }

  int getTotalPages() {
    return (_posts.length / SiteConfig.postsPerPage).ceil();
  }

  List<BlogPost> getPostsForPage(int page) {
    final startIndex = (page - 1) * SiteConfig.postsPerPage;
    final endIndex = startIndex + SiteConfig.postsPerPage;
    final sortedPosts = List<BlogPost>.from(_posts)
      ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

    if (startIndex >= sortedPosts.length) {
      return [];
    }

    return sortedPosts.sublist(
      startIndex,
      endIndex > sortedPosts.length ? sortedPosts.length : endIndex,
    );
  }

  void clear() {
    _posts.clear();
    _taxonomyService.clear();
  }

  BlogPost getFeaturedPost() {
    switch (SiteConfig.featuredPost['strategy']) {
      case 'tag':
        final tag = SiteConfig.featuredPost['tag'];
        final taggedPosts = _taxonomyService.getPostsByTag(tag);
        if (taggedPosts.isNotEmpty) {
          return taggedPosts.first;
        }
        break;

      case 'manual':
        final slug = SiteConfig.featuredPost['manualSlug'];
        if (slug.isNotEmpty) {
          final post = getPostBySlug(slug);
          if (post != null) {
            return post;
          }
        }
        break;

      case 'latest':
      default:
        if (_posts.isNotEmpty) {
          return _posts.first;
        }
    }

    // Fallback to latest post if enabled and no featured post found
    if (SiteConfig.featuredPost['fallbackToLatest'] && _posts.isNotEmpty) {
      return _posts.first;
    }

    throw Exception('No featured post found and no fallback available');
  }

  List<BlogPost> getNonFeaturedPosts() {
    final featuredPost = getFeaturedPost();
    return _posts.where((post) => post != featuredPost).toList();
  }
}
