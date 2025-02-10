import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../services/blog_service.dart';

/// Provider to manage the currently selected tag
final selectedTagProvider = StateProvider<String?>((ref) => null);

/// Provider to get all unique tags from posts
final allTagsProvider = Provider<List<String>>((ref) {
  final blogService = ref.watch(blogServiceProvider);
  return blogService.when(
    data: (service) {
      final allPosts = service.getAllPosts();
      final tags = <String>{};
      for (final post in allPosts) {
        tags.addAll(post.tags);
      }
      return tags.toList()..sort();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
