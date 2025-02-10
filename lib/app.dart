import 'dart:html';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'pages/home_page.dart';
import 'pages/post_page.dart';
import 'providers/theme_provider.dart';
import 'settings/styles.dart';
import 'providers/search_provider.dart';
import 'config/site_config.dart';

final routes = [
  Route(
    path: '/',
    builder: (context, state) => const HomePage(),
  ),
  Route(
    path: '/blog/:slug',
    builder: (context, state) => PostPage(slug: state.params['slug'] ?? ''),
  ),
];

// Root app component that provides the ProviderScope
class RootApp extends StatelessComponent {
  const RootApp();

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield ProviderScope(
      child: const App(),
    );
  }
}

// Main app component with the actual UI
class App extends StatelessComponent {
  const App();

  @override
  Iterable<Component> build(BuildContext context) sync* {
    // Add base Document.head for site-wide meta tags
    yield Document.head(
      title: SiteConfig.siteName,
      meta: {
        'viewport': 'width=device-width, initial-scale=1.0',
        ...SiteConfig.defaultMeta,
      },
    );

    yield Builder(
      builder: (context) sync* {
        final isDark = context.watch(isDarkProvider);
        final uri = Uri.parse(window.location.href);
        final path = uri.path;
        final searchQuery = uri.queryParameters['q'] ?? '';

        // Initialize search query from URL if present
        if (searchQuery.isNotEmpty) {
          context.read(searchQueryProvider.notifier).state = searchQuery;
        }

        // Update HTML element class for dark mode
        if (isDark) {
          document.documentElement?.classes.add('dark');
        } else {
          document.documentElement?.classes.remove('dark');
        }

        yield div(
          classes:
              'min-h-screen ${AppStyles.getBackground(isDark: isDark)} flex flex-col',
          [
            // Main content
            DomComponent(
              tag: 'main',
              classes: 'flex-grow w-full',
              children: [
                // Router content based on path
                if (path == '/' || path == '/blog')
                  const HomePage()
                else if (path.startsWith('/blog/'))
                  PostPage(slug: path.substring('/blog/'.length))
                else
                  const HomePage(),
              ],
            ),
          ],
        );
      },
    );
  }
}

void main() {
  // Initialize theme before running the app
  document.documentElement?.classes.remove('dark');

  // Run the app with ProviderScope
  runApp(const RootApp());
}
