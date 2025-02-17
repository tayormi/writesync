import 'dart:html' show InputElement;
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../providers/search_provider.dart';

class SearchBar extends StatelessComponent {
  const SearchBar();

  @override
  Iterable<Component> build(BuildContext context) sync* {
    final searchQuery = context.watch(searchQueryProvider);

    yield div(
      classes: 'relative w-full',
      [
        div(
          classes:
              'pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3',
          [
            div(
              classes: 'h-5 w-5 text-gray-400',
              attributes: {
                'viewBox': '0 0 20 20',
                'fill': 'currentColor',
                'aria-hidden': 'true',
              },
              [
                DomComponent(
                  tag: 'path',
                  attributes: {
                    'fill-rule': 'evenodd',
                    'd':
                        'M9 3.5a5.5 5.5 0 100 11 5.5 5.5 0 000-11zM2 9a7 7 0 1112.452 4.391l3.328 3.329a.75.75 0 11-1.06 1.06l-3.329-3.328A7 7 0 012 9z',
                    'clip-rule': 'evenodd',
                  },
                ),
              ],
            ),
          ],
        ),
        input(
          [],
          classes:
              'block w-full rounded-lg border border-gray-300 py-2 pl-10 pr-3 text-sm placeholder:text-gray-400 focus:border-brand focus:outline-none focus:ring-1 focus:ring-brand dark:bg-gray-800 dark:border-gray-700 dark:text-white dark:placeholder:text-gray-500',
          attributes: {
            'type': 'search',
            'placeholder': 'Search posts...',
            'value': searchQuery,
          },
          events: {
            'input': (event) {
              final value = (event.target as InputElement).value ?? '';
              context.read(searchQueryProvider.notifier).state = value;
            },
          },
        ),
        if (searchQuery.isNotEmpty)
          button(
            classes:
                'absolute inset-y-0 right-0 flex items-center pr-3 text-gray-400 hover:text-gray-500 dark:hover:text-gray-300',
            events: {
              'click': (event) {
                context.read(searchQueryProvider.notifier).state = '';
              },
            },
            [
              DomComponent(
                tag: 'svg',
                classes: 'h-5 w-5',
                attributes: {
                  'viewBox': '0 0 20 20',
                  'fill': 'currentColor',
                  'aria-hidden': 'true',
                },
                children: [
                  DomComponent(
                    tag: 'path',
                    attributes: {
                      'd':
                          'M6.28 5.22a.75.75 0 00-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 101.06 1.06L10 11.06l3.72 3.72a.75.75 0 101.06-1.06L11.06 10l3.72-3.72a.75.75 0 00-1.06-1.06L10 8.94 6.28 5.22z',
                    },
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
