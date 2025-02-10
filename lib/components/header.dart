import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../providers/theme_provider.dart';
import '../config/site_config.dart';

class Header extends StatefulComponent {
  const Header();

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool _isMobileMenuOpen = false;

  void _toggleMobileMenu() {
    setState(() {
      _isMobileMenuOpen = !_isMobileMenuOpen;
    });
  }

  @override
  Iterable<Component> build(BuildContext context) sync* {
    final themeMode = context.watch(themeProvider);
    final isDark = context.watch(isDarkProvider);

    yield header(
      classes:
          'sticky top-0 z-50 w-full border-b bg-white border-gray-200 dark:bg-gray-900 dark:border-gray-800',
      [
        div(
          classes: 'mx-auto ${SiteConfig.layout['maxWidth']}',
          [
            div(
              classes: SiteConfig.layout['containerPadding']!,
              [
                div(
                  classes:
                      'flex ${SiteConfig.layout['headerHeight']} items-center justify-between',
                  [
                    // Logo and site title
                    a(
                      href: '/',
                      classes:
                          'flex items-center gap-2 text-lg font-semibold text-gray-900 dark:text-white',
                      [
                        // Logo image
                        img(
                          src: SiteConfig.siteLogo,
                          classes: 'h-10 w-10 object-contain',
                          alt: '${SiteConfig.siteName} logo',
                        ),
                        // Site name - hide on mobile, show on larger screens
                        span(
                          classes: 'hidden sm:inline-block text-xl',
                          [text(SiteConfig.siteName)],
                        ),
                      ],
                    ),
                    // Navigation and theme toggle
                    div(
                      classes: 'flex items-center gap-4',
                      [
                        // Navigation - hide on mobile, show on larger screens
                        nav(
                          classes: 'hidden sm:flex items-center gap-8',
                          [
                            for (final item in SiteConfig.navigation)
                              a(
                                href: item['path']!,
                                classes:
                                    'text-sm font-semibold text-gray-700 hover:text-gray-900 dark:text-gray-300 dark:hover:text-white',
                                [text(item['label']!)],
                              ),
                          ],
                        ),
                        // Mobile menu button
                        button(
                          classes:
                              'sm:hidden p-2 text-gray-500 hover:text-gray-900 dark:text-gray-400 dark:hover:text-gray-100',
                          attributes: {'aria-label': 'Menu'},
                          events: {
                            'click': (event) => _toggleMobileMenu(),
                          },
                          [
                            DomComponent(
                              tag: 'svg',
                              classes: 'h-6 w-6',
                              attributes: {
                                'fill': 'none',
                                'viewBox': '0 0 24 24',
                                'stroke': 'currentColor',
                              },
                              children: [
                                DomComponent(
                                  tag: 'path',
                                  attributes: {
                                    'stroke-linecap': 'round',
                                    'stroke-linejoin': 'round',
                                    'stroke-width': '2',
                                    'd': _isMobileMenuOpen
                                        ? 'M6 18L18 6M6 6l12 12' // X icon
                                        : 'M4 6h16M4 12h16M4 18h16', // Hamburger icon
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Theme toggle button
                        if (SiteConfig.enableDarkMode)
                          button(
                            classes:
                                'p-2 text-gray-500 hover:text-gray-900 dark:text-gray-400 dark:hover:text-gray-100',
                            attributes: {'aria-label': 'Toggle theme'},
                            events: {
                              'click': (event) {
                                final notifier =
                                    context.read(themeProvider.notifier);
                                notifier.toggleTheme();
                              }
                            },
                            [
                              // Show different icons based on theme
                              if (themeMode == ThemeMode.system)
                                text('🖥️')
                              else if (isDark)
                                text('🌙')
                              else
                                text('☀️'),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
                // Mobile navigation menu - toggle visibility based on state
                div(
                  classes: 'sm:hidden ${_isMobileMenuOpen ? '' : 'hidden'}',
                  attributes: {'id': 'mobile-menu'},
                  [
                    div(
                      classes: 'space-y-1 px-2 pb-3 pt-2',
                      [
                        for (final item in SiteConfig.navigation)
                          a(
                            href: item['path']!,
                            classes:
                                'block rounded-lg px-3 py-2 text-base font-semibold text-gray-700 hover:bg-gray-50 hover:text-gray-900 dark:text-gray-300 dark:hover:bg-gray-800 dark:hover:text-white',
                            events: {
                              'click': (event) => _toggleMobileMenu(),
                            },
                            [text(item['label']!)],
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
