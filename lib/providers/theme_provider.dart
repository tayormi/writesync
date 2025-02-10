import 'dart:html';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';

enum ThemeMode {
  light,
  dark,
  system,
}

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    // Ensure dark mode is off at initialization
    document.documentElement?.classes.remove('dark');
  }

  bool get isDark {
    if (state == ThemeMode.system) {
      // Check if system is in dark mode using window.matchMedia
      final darkModeQuery = window.matchMedia('(prefers-color-scheme: dark)');
      return darkModeQuery.matches;
    }
    return state == ThemeMode.dark;
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    if (isDark) {
      document.documentElement?.classes.add('dark');
    } else {
      document.documentElement?.classes.remove('dark');
    }
  }

  void toggleTheme() {
    final wasInDarkMode = isDark;
    if (state == ThemeMode.system) {
      state = wasInDarkMode ? ThemeMode.light : ThemeMode.dark;
    } else {
      state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    }

    // Update dark mode class based on new state
    if (state == ThemeMode.dark) {
      document.documentElement?.classes.add('dark');
    } else {
      document.documentElement?.classes.remove('dark');
    }
  }
}

// Provider for the theme mode state
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

// Provider for the dark mode state
final isDarkProvider = Provider<bool>((ref) {
  final themeNotifier = ref.watch(themeProvider.notifier);
  return themeNotifier.isDark;
});
