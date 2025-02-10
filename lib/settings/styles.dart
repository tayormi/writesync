class AppStyles {
  // Colors
  static const Map<String, dynamic> colors = {
    'primary': 'brand',
    'primary-light': 'brand-light',
    'primary-dark': 'brand-dark',
    'background': <String, String>{
      'light': 'bg-white',
      'dark': 'dark:bg-gray-900',
    },
    'text': <String, Map<String, String>>{
      'primary': {
        'light': 'text-gray-900',
        'dark': 'dark:text-white',
      },
      'secondary': {
        'light': 'text-gray-600',
        'dark': 'dark:text-gray-300',
      },
      'muted': {
        'light': 'text-gray-500',
        'dark': 'dark:text-gray-400',
      },
    },
    'border': <String, String>{
      'light': 'border-gray-200',
      'dark': 'dark:border-gray-700',
    },
  };

  // Layout
  static const Map<String, String> layout = {
    'container': 'mx-auto max-w-7xl px-4 sm:px-6 lg:px-8',
    'section': 'py-12',
    'header-height': 'h-16',
  };

  // Components
  static const Map<String, Map<String, String>> components = {
    'header': {
      'wrapper': 'fixed w-full top-0 z-50',
      'nav': 'hidden md:flex items-center gap-x-8',
    },
    'button': {
      'base': 'rounded-lg',
      'primary': 'bg-brand text-white hover:bg-brand-dark',
      'secondary': 'bg-white text-gray-900 hover:bg-gray-50',
      'outline': 'border border-gray-300 text-gray-700 hover:bg-gray-50',
      'icon':
          'p-2 text-gray-500 dark:text-gray-400 hover:text-gray-900 dark:hover:text-gray-100 hover:bg-gray-100 dark:hover:bg-gray-700',
    },
    'link': {
      'nav':
          'text-sm font-semibold leading-6 text-gray-900 dark:text-gray-100 hover:text-brand dark:hover:text-brand-light',
    },
    'logo': {
      'wrapper': 'flex items-center gap-x-2',
      'icon': 'flex h-8 w-8 items-center justify-center rounded-lg bg-brand',
      'text': 'text-lg font-semibold leading-6 text-gray-900 dark:text-white',
    },
  };

  // Utils
  static String getBackground({bool isDark = false}) {
    final bg = colors['background'] as Map<String, String>;
    return '${bg['light']} ${isDark ? bg['dark'] : ''}';
  }

  static String getTextColor({bool primary = true, bool isDark = false}) {
    final textColors = colors['text'] as Map<String, Map<String, String>>;
    final type = primary ? 'primary' : 'secondary';
    final variant = textColors[type]!;
    return '${variant['light']} ${isDark ? variant['dark'] : ''}';
  }

  static String getBorderColor({bool isDark = false}) {
    final border = colors['border'] as Map<String, String>;
    return '${border['light']} ${isDark ? border['dark'] : ''}';
  }
}
