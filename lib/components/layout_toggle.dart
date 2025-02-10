import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../providers/layout_provider.dart';
import '../config/site_config.dart';
import '../providers/theme_provider.dart';

class LayoutToggle extends StatelessComponent {
  const LayoutToggle();

  @override
  Iterable<Component> build(BuildContext context) sync* {
    final currentLayout = context.watch(blogLayoutProvider);
    final isDark = context.watch(isDarkProvider);

    yield div(
      classes: 'flex items-center space-x-2',
      [
        // Grid button
        button(
          classes: '''
            p-2 rounded-lg transition-colors
            ${currentLayout == BlogLayout.grid ? SiteConfig.getPrimaryLightClasses(isDark: isDark) : 'text-gray-600 hover:bg-gray-100 dark:text-gray-400 dark:hover:bg-gray-800'}
          ''',
          events: {
            'click': (event) {
              context.read(blogLayoutProvider.notifier).state = BlogLayout.grid;
            },
          },
          [
            DomComponent(
              tag: 'svg',
              attributes: {
                'viewBox': '0 0 24 24',
                'width': '20',
                'height': '20',
                'fill': 'currentColor',
              },
              children: [
                DomComponent(
                  tag: 'path',
                  attributes: {
                    'd':
                        'M4 4h4v4H4V4zm6 0h4v4h-4V4zm6 0h4v4h-4V4zm-12 6h4v4H4v-4zm6 0h4v4h-4v-4zm6 0h4v4h-4v-4zm-12 6h4v4H4v-4zm6 0h4v4h-4v-4zm6 0h4v4h-4v-4z',
                  },
                ),
              ],
            ),
          ],
        ),
        // List button
        button(
          classes: '''
            p-2 rounded-lg transition-colors
            ${currentLayout == BlogLayout.list ? SiteConfig.getPrimaryLightClasses(isDark: isDark) : 'text-gray-600 hover:bg-gray-100 dark:text-gray-400 dark:hover:bg-gray-800'}
          ''',
          events: {
            'click': (event) {
              context.read(blogLayoutProvider.notifier).state = BlogLayout.list;
            },
          },
          [
            DomComponent(
              tag: 'svg',
              attributes: {
                'viewBox': '0 0 24 24',
                'width': '20',
                'height': '20',
                'fill': 'currentColor',
              },
              children: [
                DomComponent(
                  tag: 'path',
                  attributes: {
                    'd': 'M4 6h16v2H4V6zm0 5h16v2H4v-2zm0 5h16v2H4v-2z',
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
