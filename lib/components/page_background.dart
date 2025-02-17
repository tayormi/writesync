import 'package:jaspr/jaspr.dart';

class PageBackground extends StatelessComponent {
  final List<Component> children;
  final bool withGradient;

  const PageBackground({
    required this.children,
    this.withGradient = true,
  });

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div(
      classes: withGradient
          ? '''
            relative min-h-screen
            bg-gradient-to-b from-brand/10 via-brand/5 to-transparent
            dark:from-brand-dark/15 dark:via-brand-dark/5 dark:to-transparent
          '''
          : 'relative min-h-screen',
      [
        // Subtle grid pattern overlay
        div(
          classes: '''
            absolute inset-0 bg-grid-pattern opacity-[0.075] dark:opacity-[0.15]
            pointer-events-none
          ''',
          [],
        ),
        // Radial gradient overlay for depth
        div(
          classes: '''
            absolute inset-0 
            bg-[radial-gradient(ellipse_at_top,_transparent_50%,_rgba(255,255,255,0.9))]
            dark:bg-[radial-gradient(ellipse_at_top,_transparent_50%,_rgba(17,24,39,0.9))]
            pointer-events-none
          ''',
          [],
        ),
        // Additional gradient for more depth
        div(
          classes: '''
            absolute inset-0 
            bg-gradient-to-t from-white/80 via-transparent to-transparent
            dark:from-gray-900/80 dark:via-transparent dark:to-transparent
            pointer-events-none
          ''',
          [],
        ),
        // Content
        div(
          classes: 'relative',
          children,
        ),
      ],
    );
  }
}
