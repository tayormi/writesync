import 'dart:html';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_blog/pages/search_page.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'pages/home_page.dart';
import 'pages/post_page.dart';
import 'config/site_config.dart';
import 'services/performance_monitor.dart';
import 'components/performance_dashboard.dart';

// Define routes for the application
final routes = [
  Route(
    path: '/',
    builder: (context, state) => const HomePage(),
  ),
  Route(
    path: '/blog/:slug',
    builder: (context, state) => PostPage(slug: state.params['slug'] ?? ''),
  ),
  Route(
    path: '/search',
    builder: (context, state) => const SearchPage(),
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
class App extends StatefulComponent {
  const App();

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    // Initialize performance monitoring
    context.read(performanceMonitorProvider).initialize();
  }

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

    yield div(
      classes: 'relative',
      [
        Router(
          routes: routes,
        ),
        // Add performance dashboard
        if (SiteConfig.enablePerformanceMonitoring)
          const PerformanceDashboard(),
      ],
    );
  }
}

void main() {
  // Initialize theme before running the app
  document.documentElement?.classes.remove('dark');

  // Run the app with ProviderScope
  runApp(const RootApp());
}
