import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../models/blog_post.dart';

final taxonomyServiceProvider =
    Provider<TaxonomyService>((ref) => TaxonomyService.instance);

class TaxonomyService {
  static final TaxonomyService instance = TaxonomyService._();
  TaxonomyService._();

  final Map<String, Set<BlogPost>> _tagToPosts = {};
  final Map<String, Set<BlogPost>> _authorToPosts = {};
  final Map<String, Set<BlogPost>> _yearToPosts = {};
  final Map<String, Set<BlogPost>> _monthToPosts = {};

  void indexPost(BlogPost post) {
    // Index by tags
    for (final tag in post.tags) {
      _tagToPosts.putIfAbsent(tag, () => {}).add(post);
    }

    // Index by author
    _authorToPosts.putIfAbsent(post.author, () => {}).add(post);

    // Index by year
    final year = post.publishedAt.year.toString();
    _yearToPosts.putIfAbsent(year, () => {}).add(post);

    // Index by month
    final month =
        '${post.publishedAt.year}-${post.publishedAt.month.toString().padLeft(2, '0')}';
    _monthToPosts.putIfAbsent(month, () => {}).add(post);
  }

  void removePost(BlogPost post) {
    // Remove from tags
    for (final tag in post.tags) {
      _tagToPosts[tag]?.remove(post);
      if (_tagToPosts[tag]?.isEmpty ?? false) {
        _tagToPosts.remove(tag);
      }
    }

    // Remove from author
    _authorToPosts[post.author]?.remove(post);
    if (_authorToPosts[post.author]?.isEmpty ?? false) {
      _authorToPosts.remove(post.author);
    }

    // Remove from year
    final year = post.publishedAt.year.toString();
    _yearToPosts[year]?.remove(post);
    if (_yearToPosts[year]?.isEmpty ?? false) {
      _yearToPosts.remove(year);
    }

    // Remove from month
    final month =
        '${post.publishedAt.year}-${post.publishedAt.month.toString().padLeft(2, '0')}';
    _monthToPosts[month]?.remove(post);
    if (_monthToPosts[month]?.isEmpty ?? false) {
      _monthToPosts.remove(month);
    }
  }

  List<BlogPost> getPostsByTag(String tag) {
    return _tagToPosts[tag]?.toList() ?? [];
  }

  List<BlogPost> getPostsByAuthor(String author) {
    return _authorToPosts[author]?.toList() ?? [];
  }

  List<BlogPost> getPostsByYear(String year) {
    return _yearToPosts[year]?.toList() ?? [];
  }

  List<BlogPost> getPostsByMonth(String month) {
    return _monthToPosts[month]?.toList() ?? [];
  }

  List<String> getAllTags() {
    return _tagToPosts.keys.toList()..sort();
  }

  List<String> getAllAuthors() {
    return _authorToPosts.keys.toList()..sort();
  }

  List<String> getAllYears() {
    return _yearToPosts.keys.toList()..sort();
  }

  List<String> getAllMonths() {
    return _monthToPosts.keys.toList()..sort();
  }

  Map<String, int> getTagCounts() {
    return Map.fromEntries(
      _tagToPosts.entries.map(
        (e) => MapEntry(e.key, e.value.length),
      ),
    );
  }

  void clear() {
    _tagToPosts.clear();
    _authorToPosts.clear();
    _yearToPosts.clear();
    _monthToPosts.clear();
  }
}
