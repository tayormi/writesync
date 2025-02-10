import 'package:jaspr_riverpod/jaspr_riverpod.dart';

const int postsPerPage = 6;

final currentPageProvider = StateProvider<int>((ref) => 1);

final paginationProvider = StateNotifierProvider<PaginationNotifier,
    ({int totalPages, List<int> visiblePages})>((ref) {
  return PaginationNotifier();
});

class PaginationNotifier
    extends StateNotifier<({int totalPages, List<int> visiblePages})> {
  PaginationNotifier() : super((totalPages: 1, visiblePages: [1]));

  void updatePagination(int totalPosts, int currentPage) {
    final totalPages = (totalPosts / postsPerPage).ceil();

    // Ensure current page is within valid range
    if (currentPage > totalPages) {
      currentPage = totalPages;
    }

    final visiblePages = _calculateVisiblePages(currentPage, totalPages);
    state = (totalPages: totalPages, visiblePages: visiblePages);
  }

  List<int> _calculateVisiblePages(int currentPage, int totalPages) {
    const maxVisiblePages = 5;
    final pages = <int>[];

    if (totalPages <= maxVisiblePages) {
      // Show all pages if total pages is less than or equal to max visible pages
      pages.addAll(List.generate(totalPages, (i) => i + 1));
    } else {
      // Always show first page
      pages.add(1);

      // Calculate start and end of visible pages
      var start = currentPage - 1;
      var end = currentPage + 1;

      // Adjust start and end to show maxVisiblePages - 2 pages (excluding first and last)
      if (start <= 2) {
        start = 2;
        end = start + 2;
      } else if (end >= totalPages - 1) {
        end = totalPages - 1;
        start = end - 2;
      }

      // Add ellipsis if needed
      if (start > 2) pages.add(-1);

      // Add visible pages
      for (var i = start; i <= end; i++) {
        pages.add(i);
      }

      // Add ellipsis if needed
      if (end < totalPages - 1) pages.add(-1);

      // Always show last page if there's more than one page
      if (totalPages > 1) {
        pages.add(totalPages);
      }
    }

    return pages;
  }
}
