import 'dart:html';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';

enum ThemeMode {
  light,
  dark,
  system,
}

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(_loadTheme()) {
    _updateThemeClass();

    // Listen to system theme changes if in system mode
    if (state == ThemeMode.system) {
      final darkModeQuery = window.matchMedia('(prefers-color-scheme: dark)');
      darkModeQuery.addListener((event) {
        if (state == ThemeMode.system) {
          _updateThemeClass();
        }
      });
    }
  }

  static ThemeMode _loadTheme() {
    final savedTheme = window.localStorage['theme'];
    if (savedTheme != null) {
      return ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }
    return ThemeMode.system;
  }

  void _saveTheme(ThemeMode mode) {
    window.localStorage['theme'] = mode.toString();
  }

  bool get isDark {
    if (state == ThemeMode.system) {
      final darkModeQuery = window.matchMedia('(prefers-color-scheme: dark)');
      return darkModeQuery.matches;
    }
    return state == ThemeMode.dark;
  }

  void _updateThemeClass() {
    if (isDark) {
      document.documentElement?.classes.add('dark');
    } else {
      document.documentElement?.classes.remove('dark');
    }
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    _saveTheme(mode);
    _updateThemeClass();
  }

  void toggleTheme() {
    final wasInDarkMode = isDark;
    if (state == ThemeMode.system) {
      state = wasInDarkMode ? ThemeMode.light : ThemeMode.dark;
    } else {
      state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    }
    _saveTheme(state);
    _updateThemeClass();
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
