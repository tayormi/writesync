// The entrypoint for the **client** environment.
//
// This file is compiled to javascript and executed in the browser.

// Client-specific jaspr import.
import 'package:jaspr/browser.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
// Imports the [App] component.
import 'package:jaspr_blog/app.dart';
import 'package:jaspr_blog/services/blog_service.dart';

void main() async {
  try {
    print('Initializing blog service...');
    await BlogService().initialize();
    print('Blog service initialized');

    print('Starting app...');
    runApp(
      ProviderScope(
        child: const App(),
      ),
    );
    print('App started');
  } catch (e, stackTrace) {
    print('Error starting app: $e');
    print('Stack trace: $stackTrace');
  }
}
