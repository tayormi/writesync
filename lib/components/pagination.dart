import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../providers/pagination_provider.dart';
import '../config/site_config.dart';
import '../providers/theme_provider.dart';

class Pagination extends StatelessComponent {
  const Pagination();

  void _changePage(BuildContext context, int newPage) {
    final paginationState = context.read(paginationProvider);
    if (newPage >= 1 && newPage <= paginationState.totalPages) {
      context.read(currentPageProvider.notifier).state = newPage;
    }
  }

  @override
  Iterable<Component> build(BuildContext context) sync* {
    final currentPage = context.watch(currentPageProvider);
    final paginationState = context.watch(paginationProvider);
    final isDark = context.watch(isDarkProvider);

    yield nav(
      attributes: {'role': 'navigation', 'aria-label': 'Pagination'},
      classes: 'flex items-center justify-center space-x-2 mt-12',
      [
        // Previous page button
        button(
          classes: '''
            relative inline-flex items-center px-4 py-2 text-sm font-medium 
            ${currentPage > 1 ? 'text-gray-700 bg-white border border-gray-300 hover:bg-gray-50 dark:text-gray-300 dark:bg-gray-800 dark:border-gray-600 dark:hover:bg-gray-700' : 'text-gray-400 bg-gray-100 cursor-not-allowed dark:text-gray-500 dark:bg-gray-800'}
            rounded-md transition-colors duration-200
          ''',
          attributes: {
            'type': 'button',
            'disabled': currentPage <= 1 ? 'true' : 'false',
            'aria-label': 'Previous page',
          },
          events: {
            'click': (event) {
              if (currentPage > 1) {
                _changePage(context, currentPage - 1);
              }
            },
          },
          [text('Previous')],
        ),

        // Page numbers
        for (final page in paginationState.visiblePages)
          if (page == -1)
            // Ellipsis
            span(
              classes: 'px-4 py-2 text-gray-700 dark:text-gray-300',
              [text('...')],
            )
          else
            button(
              classes: '''
                relative inline-flex items-center px-4 py-2 text-sm font-semibold
                ${page == currentPage ? SiteConfig.getPrimaryClasses(isDark: isDark) : 'text-gray-700 bg-white border border-gray-300 hover:bg-gray-50 dark:text-gray-300 dark:bg-gray-800 dark:border-gray-600 dark:hover:bg-gray-700'}
              ''',
              attributes: {
                'type': 'button',
                'aria-label': 'Page $page',
                'aria-current': page == currentPage ? 'true' : 'false',
              },
              events: {
                'click': (event) => _changePage(context, page),
              },
              [text('$page')],
            ),

        // Next page button
        button(
          classes: '''
            relative inline-flex items-center px-4 py-2 text-sm font-medium 
            ${currentPage < paginationState.totalPages ? 'text-gray-700 bg-white border border-gray-300 hover:bg-gray-50 dark:text-gray-300 dark:bg-gray-800 dark:border-gray-600 dark:hover:bg-gray-700' : 'text-gray-400 bg-gray-100 cursor-not-allowed dark:text-gray-500 dark:bg-gray-800'}
            rounded-md transition-colors duration-200
          ''',
          attributes: {
            'type': 'button',
            'disabled':
                currentPage >= paginationState.totalPages ? 'true' : 'false',
            'aria-label': 'Next page',
          },
          events: {
            'click': (event) {
              if (currentPage < paginationState.totalPages) {
                _changePage(context, currentPage + 1);
              }
            },
          },
          [text('Next')],
        ),
      ],
    );
  }
}
