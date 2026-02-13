import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:jaspr_riverpod/legacy.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchUrlProvider = Provider<String>((ref) {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return '/blog';
  return '/blog?q=${Uri.encodeComponent(query)}';
});
