import 'package:jaspr/jaspr.dart';
import '../components/layout.dart';
import '../config/site_config.dart';

class AboutPage extends StatelessComponent {
  const AboutPage({super.key});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield Layout(
      withGradient: true,
      children: [
        // Hero section
        div(
          classes: 'py-20',
          [
            div(
              classes: 'container mx-auto px-4',
              [
                div(
                  classes: 'max-w-3xl mx-auto text-center',
                  [
                    h1(
                      classes: '''
                        text-5xl font-bold text-gray-900 dark:text-white mb-6
                        bg-clip-text text-transparent bg-gradient-to-r 
                        from-brand to-brand-dark dark:from-brand-light dark:to-brand
                      ''',
                      [text('About ${SiteConfig.siteName}')],
                    ),
                    p(
                      classes: '''
                        text-xl text-gray-600 dark:text-gray-400
                        max-w-2xl mx-auto leading-relaxed
                      ''',
                      [text(SiteConfig.siteDescription)],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // Main content
        div(
          classes: 'container mx-auto px-4 py-12',
          [
            div(
              classes: 'max-w-4xl mx-auto',
              [
                // What is WriteSync section
                section(
                  classes: '''
                    bg-white dark:bg-gray-800 rounded-xl p-8 mb-12
                    shadow-lg hover:shadow-xl transition-shadow duration-300
                  ''',
                  [
                    h2(
                      classes: '''
                        text-3xl font-bold mb-6 
                        text-gray-900 dark:text-white
                        border-b border-gray-200 dark:border-gray-700 pb-4
                      ''',
                      [text('What is WriteSync?')],
                    ),
                    div(
                      classes: 'space-y-4 text-gray-600 dark:text-gray-300',
                      [
                        p([
                          text(
                              'WriteSync is a modern blog engine built with Dart and Jaspr, designed to provide a seamless writing and reading experience. It combines the performance benefits of server-side rendering with the rich interactivity of client-side applications.'),
                        ]),
                        p([
                          text(
                              'What sets WriteSync apart is its focus on developer experience and content management. Writers can author content in Markdown while maintaining full control over their content\'s presentation and structure.'),
                        ]),
                      ],
                    ),
                  ],
                ),

                // Features grid
                section(
                  classes: 'mb-12',
                  [
                    h2(
                      classes: '''
                        text-3xl font-bold mb-8 text-center
                        text-gray-900 dark:text-white
                      ''',
                      [text('Key Features')],
                    ),
                    div(
                      classes: 'grid md:grid-cols-2 gap-6',
                      [
                        // Feature cards
                        _featureCard(
                          'Markdown-First Content',
                          'Write your posts in Markdown with support for code syntax highlighting, tables, and rich media.',
                          'M19.707 4.293a1 1 0 0 0-1.414 0L10 12.586 5.707 8.293a1 1 0 0 0-1.414 1.414l5 5a1 1 0 0 0 1.414 0l9-9a1 1 0 0 0 0-1.414z',
                        ),
                        _featureCard(
                          'Performance Optimized',
                          'Server-side rendering combined with client-side hydration for optimal loading speeds and SEO.',
                          'M13 10V3L4 14h7v7l9-11h-7z',
                        ),
                        _featureCard(
                          'Smart Content Organization',
                          'Automatic taxonomy generation, tag-based navigation, and smart search capabilities.',
                          'M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2',
                        ),
                        _featureCard(
                          'Modern UI & Analytics',
                          'Responsive design with dark mode support and built-in analytics integration.',
                          'M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z',
                        ),
                      ],
                    ),
                  ],
                ),

                // Technical Architecture section
                section(
                  classes: '''
                    bg-gray-50 dark:bg-gray-800/50 rounded-xl p-8 mb-12
                    backdrop-blur-sm
                  ''',
                  [
                    h2(
                      classes: '''
                        text-3xl font-bold mb-6 text-center
                        text-gray-900 dark:text-white
                      ''',
                      [text('Technical Architecture')],
                    ),
                    div(
                      classes: 'grid md:grid-cols-2 gap-6',
                      [
                        _techCard(
                          'Jaspr Framework',
                          'Utilizing Dart\'s powerful web framework for server-side rendering and client-side interactivity.',
                        ),
                        _techCard(
                          'State Management',
                          'Riverpod for predictable state management and dependency injection.',
                        ),
                        _techCard(
                          'Build System',
                          'Custom build pipeline for processing Markdown files and generating optimized blog posts.',
                        ),
                        _techCard(
                          'Performance Monitoring',
                          'Built-in performance dashboard for monitoring Web Vitals and user experience metrics.',
                        ),
                      ],
                    ),
                  ],
                ),

                // For Developers section
                section(
                  classes: '''
                    bg-brand/5 dark:bg-brand-dark/5 rounded-xl p-8 mb-12
                    border border-brand/10 dark:border-brand-dark/10
                  ''',
                  [
                    h2(
                      classes: '''
                        text-3xl font-bold mb-6 text-center
                        text-gray-900 dark:text-white
                      ''',
                      [text('For Developers')],
                    ),
                    div(
                      classes: 'grid md:grid-cols-2 gap-6',
                      [
                        _devCard(
                          'Customize',
                          'Fork and customize the platform for your needs',
                          'M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4',
                        ),
                        _devCard(
                          'Contribute',
                          'Contribute to the core features and improvements',
                          'M12 4v16m8-8H4',
                        ),
                        _devCard(
                          'Learn',
                          'Use it as a learning resource for Jaspr and Dart web development',
                          'M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253',
                        ),
                        _devCard(
                          'Integrate',
                          'Integrate additional features and analytics providers',
                          'M11 4a2 2 0 114 0v1a1 1 0 001 1h3a1 1 0 011 1v3a1 1 0 01-1 1h-1a2 2 0 100 4h1a1 1 0 011 1v3a1 1 0 01-1 1h-3a1 1 0 01-1-1v-1a2 2 0 10-4 0v1a1 1 0 01-1 1H7a1 1 0 01-1-1v-3a1 1 0 00-1-1H4a2 2 0 110-4h1a1 1 0 001-1V7a1 1 0 011-1h3a1 1 0 001-1V4z',
                        ),
                      ],
                    ),
                  ],
                ),

                // Get Started section
                section(
                  classes: '''
                    bg-white dark:bg-gray-800 rounded-xl p-8 mb-12
                    text-center shadow-lg
                  ''',
                  [
                    h2(
                      classes:
                          'text-3xl font-bold mb-6 text-gray-900 dark:text-white',
                      [text('Get Started')],
                    ),
                    p(
                      classes: 'text-gray-600 dark:text-gray-300 mb-8',
                      [
                        text('Visit our '),
                        a(
                          href: '${SiteConfig.socialLinks['github']}',
                          classes:
                              'text-brand dark:text-brand-light hover:underline',
                          [text('GitHub repository')],
                        ),
                        text(
                            ' to get started with WriteSync. The repository includes detailed documentation, setup instructions, and examples.'),
                      ],
                    ),
                    // GitHub button
                    a(
                      href: '${SiteConfig.socialLinks['github']}',
                      classes: '''
                        inline-flex items-center px-6 py-3 rounded-lg
                        bg-gray-900 dark:bg-white text-white dark:text-gray-900
                        hover:bg-gray-800 dark:hover:bg-gray-100 transition-colors
                        font-semibold text-sm
                      ''',
                      [
                        // GitHub icon
                        DomComponent(
                          tag: 'svg',
                          classes: 'w-5 h-5 mr-2',
                          attributes: {
                            'fill': 'currentColor',
                            'viewBox': '0 0 24 24',
                          },
                          children: [
                            DomComponent(
                              tag: 'path',
                              attributes: {
                                'd':
                                    'M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z',
                              },
                            ),
                          ],
                        ),
                        text('View on GitHub'),
                      ],
                    ),
                  ],
                ),

                // Connect section
                section(
                  classes: 'text-center',
                  [
                    h2(
                      classes:
                          'text-3xl font-bold mb-6 text-gray-900 dark:text-white',
                      [text('Connect')],
                    ),
                    p(
                      classes: 'text-gray-600 dark:text-gray-300 mb-6',
                      [text('Join our community and stay updated:')],
                    ),
                    div(
                      classes: 'flex justify-center gap-4',
                      [
                        for (final entry in SiteConfig.socialLinks.entries)
                          a(
                            href: entry.value,
                            classes: '''
                              px-6 py-3 rounded-lg
                              bg-gray-100 dark:bg-gray-800
                              text-gray-900 dark:text-white
                              hover:bg-gray-200 dark:hover:bg-gray-700
                              transition-colors font-medium
                            ''',
                            [text(entry.key)],
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

  Component _featureCard(String title, String description, String svgPath) {
    return div(
      classes: '''
        bg-white dark:bg-gray-800 rounded-xl p-6
        shadow-lg hover:shadow-xl transition-shadow duration-300
        border border-gray-100 dark:border-gray-700
      ''',
      [
        div(
          classes: 'flex items-center gap-4 mb-4',
          [
            div(
              classes: '''
                w-12 h-12 rounded-lg bg-brand/10 dark:bg-brand-dark/10
                flex items-center justify-center
              ''',
              [
                DomComponent(
                  tag: 'svg',
                  classes: 'w-6 h-6 text-brand dark:text-brand-light',
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
                        'd': svgPath,
                      },
                    ),
                  ],
                ),
              ],
            ),
            h3(
              classes: 'text-xl font-semibold text-gray-900 dark:text-white',
              [text(title)],
            ),
          ],
        ),
        p(
          classes: 'text-gray-600 dark:text-gray-300',
          [text(description)],
        ),
      ],
    );
  }

  Component _techCard(String title, String description) {
    return div(
      classes: '''
        bg-white dark:bg-gray-800 rounded-lg p-6
        border border-gray-100 dark:border-gray-700
      ''',
      [
        h3(
          classes: 'text-xl font-semibold mb-3 text-gray-900 dark:text-white',
          [text(title)],
        ),
        p(
          classes: 'text-gray-600 dark:text-gray-300',
          [text(description)],
        ),
      ],
    );
  }

  Component _devCard(String title, String description, String svgPath) {
    return div(
      classes: '''
        bg-white dark:bg-gray-800 rounded-lg p-6
        border border-gray-100 dark:border-gray-700
        hover:border-brand dark:hover:border-brand-light
        transition-colors duration-300
      ''',
      [
        div(
          classes: '''
            w-12 h-12 rounded-lg bg-brand/10 dark:bg-brand-dark/10
            flex items-center justify-center mb-4
          ''',
          [
            DomComponent(
              tag: 'svg',
              classes: 'w-6 h-6 text-brand dark:text-brand-light',
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
                    'd': svgPath,
                  },
                ),
              ],
            ),
          ],
        ),
        h3(
          classes: 'text-xl font-semibold mb-2 text-gray-900 dark:text-white',
          [text(title)],
        ),
        p(
          classes: 'text-gray-600 dark:text-gray-300',
          [text(description)],
        ),
      ],
    );
  }
}
