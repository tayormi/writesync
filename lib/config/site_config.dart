class SiteConfig {
  // Site Information
  static const String siteName = 'WriteSync';
  static const String siteDescription =
      'WriteSync is a blog engine built with Dart and Jaspr.';
  static const String siteAuthor = 'Your Name';
  static const String siteKeywords = 'your, keywords, here';
  static const String siteLogo = '/images/logo.png';

  // SEO Configuration
  static const Map<String, String> defaultMeta = {
    'title': siteName,
    'description': siteDescription,
    'author': siteAuthor,
    'keywords': siteKeywords,
    'og:type': 'website',
    'og:site_name': siteName,
    'twitter:card': 'summary_large_image',
    'og:image': siteLogo,
    'twitter:image': siteLogo,
  };

  // Theme Configuration
  static const Map<String, String> colors = {
    'primary': 'brand',
    'primary-light': 'brand-light',
    'primary-dark': 'brand-dark',
  };

  // Theme Colors for Light and Dark modes
  static const Map<String, Map<String, String>> themeColors = {
    'light': {
      'background': 'bg-white',
      'text': 'text-gray-900',
      'text-secondary': 'text-gray-600',
      'text-muted': 'text-gray-500',
      'border': 'border-gray-200',
      'primary': 'text-brand',
      'primary-bg': 'bg-brand',
      'primary-bg-hover': 'hover:bg-brand-dark',
      'primary-text-hover': 'hover:text-brand-dark',
      'primary-light-bg': 'bg-brand/10',
      'primary-light-text': 'text-brand',
    },
    'dark': {
      'background': 'bg-gray-900',
      'text': 'text-white',
      'text-secondary': 'text-gray-300',
      'text-muted': 'text-gray-400',
      'border': 'border-gray-800',
      'primary': 'text-brand-light',
      'primary-bg': 'bg-brand',
      'primary-bg-hover': 'hover:bg-brand-dark',
      'primary-text-hover': 'hover:text-brand-light',
      'primary-light-bg': 'bg-brand/20',
      'primary-light-text': 'text-brand-light',
    }
  };

  // Component-specific color utilities
  static String getPrimaryClasses({bool isDark = false}) {
    final mode = isDark ? 'dark' : 'light';
    return '${themeColors[mode]!['primary-bg']} ${themeColors[mode]!['primary-bg-hover']} text-white';
  }

  static String getPrimaryLightClasses({bool isDark = false}) {
    final mode = isDark ? 'dark' : 'light';
    return '${themeColors[mode]!['primary-light-bg']} ${themeColors[mode]!['primary-light-text']}';
  }

  static String getPrimaryTextClasses({bool isDark = false}) {
    final mode = isDark ? 'dark' : 'light';
    return '${themeColors[mode]!['primary']} ${themeColors[mode]!['primary-text-hover']}';
  }

  // Layout Configuration
  static const Map<String, String> layout = {
    'maxWidth': 'max-w-7xl',
    'containerPadding': 'px-4 sm:px-6 lg:px-8',
    'sectionPadding': 'py-12',
    'headerHeight': 'h-16',
  };

  // Blog Post Card Configuration
  static const Map<String, dynamic> blogPostCard = {
    'container': '''
      border-r border-b border-l border-gray-100 
      lg:border-t lg:border-gray-100 bg-white dark:bg-gray-800
      dark:border-gray-800
      hover:border-gray-200 dark:hover:border-gray-700
      rounded-b lg:rounded-b-none lg:rounded-r 
      flex flex-col h-full
      hover:shadow-lg transition-all duration-300
    ''',
    'imageContainer': '''
      w-full h-48 overflow-hidden
    ''',
    'image': '''
      w-full h-full object-cover
      hover:scale-105 transition-transform duration-200
    ''',
    'content': 'p-4 flex flex-col flex-1',
    'contentWrapper': 'flex-1 mb-4',
    'memberBadge': '''
      text-sm text-gray-600 dark:text-gray-400 
      flex items-center mb-2
    ''',
    'title': '''
      text-gray-900 dark:text-white 
      font-bold text-lg mb-2 
      hover:text-brand dark:hover:text-brand-light
      block line-clamp-2
    ''',
    'description': '''
      text-gray-700 dark:text-gray-300 
      text-sm line-clamp-3
    ''',
    'authorContainer': 'flex items-center',
    'authorImage': 'w-10 h-10 rounded-full mr-4',
    'authorInfo': 'text-sm',
    'authorName': '''
      text-gray-900 dark:text-white 
      font-semibold leading-none 
      hover:text-brand dark:hover:text-brand-light
    ''',
    'date': 'text-gray-600 dark:text-gray-400',
    'listView': <String, String>{
      'container': '''
        flex flex-row border rounded-lg overflow-hidden
        border-gray-100 dark:border-gray-800
        hover:border-gray-200 dark:hover:border-gray-700
        hover:shadow-lg transition-all duration-300
      ''',
      'imageContainer': '''
        w-48 min-w-[12rem] h-48 overflow-hidden
        flex-shrink-0
      ''',
      'content': '''
        flex-1 p-6 flex flex-col justify-between
        min-w-0
      ''',
    },
  };

  // Navigation Configuration
  static const List<Map<String, String>> navigation = [
    {'label': 'Home', 'path': '/'},
    {'label': 'Search', 'path': '/search'},
    {'label': 'About', 'path': '/about'},
  ];

  // Social Media Links
  static const Map<String, String> socialLinks = {
    'twitter': 'https://twitter.com/write_sync',
    'github': 'https://github.com/tayormi/writesync',
    'linkedin': 'https://linkedin.com/in/writesync',
  };

  // Blog Configuration
  static const int postsPerPage = 9;
  static const String postsDirectory = 'lib/posts';
  static const String defaultAuthorImage = 'https://placehold.co/400';
  static const String defaultPostImage =
      'https://images.unsplash.com/photo-1496128858413-b36217c2ce36';

  // Blog Display Configuration
  static const Map<String, bool> blogDisplay = {
    'showAuthor': false,
    'showAuthorImage': false,
    'showDate': true,
    'showTags': true,
  };

  // Footer Configuration
  static String get footerText =>
      '© ${DateTime.now().year} $siteName. All rights reserved.';

  // Feature Flags
  static const bool enableDarkMode = true;
  static const bool enableSearch = true;
  static const bool enableTags = true;
  static const bool enablePagination = true;
  static const bool enableSocialSharing = true;
  static const bool enablePerformanceMonitoring = true;

  // Cache Configuration
  static const Duration postCacheDuration = Duration(hours: 1);
  static const int maxCachedPosts = 100;

  // Analytics Configuration
  static const Map<String, dynamic> analytics = {
    'enabled': true,
    'googleAnalytics': {
      'enabled': true,
      'measurementId': 'G-XXXXXXXXXX', // Replace with your GA4 measurement ID
      'sendPerformanceMetrics': true,
      'debugMode': false,
      'customEvents': {
        'enabled': true,
        'trackPageViews': true,
        'trackClicks': true,
        'trackErrors': true,
        'trackNavigation': true,
        'trackSearch': true,
      },
      'customDimensions': {
        'environment': 'production',
        'version': '1.0.0',
        'theme': 'auto',
      },
    },
    'lukehog': {
      'enabled': true,
      'projectId': '', // Your Lukehog project ID
      'options': {
        'debugMode': false,
        'automaticPageviews': true,
        'automaticPerformanceMetrics': true,
        'automaticErrorTracking': true,
        'sessionTimeout': 1800, // 30 minutes in seconds
      },
    },
    'customAnalytics': {
      'enabled': false,
      'endpoint': '', // Your analytics API endpoint
      'apiKey': '', // Your API key
      'options': {
        'batchSize': 10,
        'batchIntervalMs': 2000,
        'retryAttempts': 3,
        'debugMode': false,
      },
      'customEvents': {
        'enabled': true,
        'trackPageViews': true,
        'trackClicks': true,
        'trackErrors': true,
        'trackPerformance': true,
      },
    },
  };

  // Featured Post Configuration
  static const Map<String, dynamic> featuredPost = {
    'strategy': 'manual', // Options: 'tag', 'latest', 'manual'
    'tag': 'featured', // Tag to use when strategy is 'tag'
    'manualSlug':
        'performance_optimization', // Slug to use when strategy is 'manual'
    'fallbackToLatest': true, // Use latest post if no featured post found
  };
}
