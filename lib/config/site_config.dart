class SiteConfig {
  // Site Information
  static const String siteName = 'WriteSync';
  static const String siteDescription =
      'WriteSync is a platform for writing and sharing your thoughts.';
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

  // Navigation Configuration
  static const List<Map<String, String>> navigation = [
    {'label': 'Home', 'path': '/'},
    {'label': 'About', 'path': '/about'},
  ];

  // Social Media Links
  static const Map<String, String> socialLinks = {
    'twitter': 'https://twitter.com/yourusername',
    'github': 'https://github.com/yourusername',
    'linkedin': 'https://linkedin.com/in/yourusername',
  };

  // Blog Configuration
  static const int postsPerPage = 9;
  static const String postsDirectory = 'web/assets/posts';
  static const String defaultAuthorImage = 'https://via.placeholder.com/150';
  static const String defaultPostImage =
      'https://images.unsplash.com/photo-1496128858413-b36217c2ce36';

  // Blog Display Configuration
  static const Map<String, bool> blogDisplay = {
    'showAuthor': false,
    'showAuthorImage': true,
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

  // Cache Configuration
  static const Duration postCacheDuration = Duration(hours: 1);
  static const int maxCachedPosts = 100;
}
