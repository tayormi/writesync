import 'package:jaspr/jaspr.dart';

class LazyComponent extends StatefulComponent {
  final Future<Component> Function() loader;
  final Component? placeholder;

  const LazyComponent({
    required this.loader,
    this.placeholder,
    super.key,
  });

  @override
  State<LazyComponent> createState() => _LazyComponentState();
}

class _LazyComponentState extends State<LazyComponent> {
  late Future<Component> _future;

  @override
  void initState() {
    super.initState();
    _future = component.loader();
  }

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield StreamBuilder<Component>(
      stream: _future.asStream(),
      builder: (context, snapshot) sync* {
        if (snapshot.hasData) {
          yield snapshot.data!;
        } else {
          yield component.placeholder ?? _buildDefaultLoader();
        }
      },
    );
  }

  Component _buildDefaultLoader() {
    return div(
      classes: 'flex justify-center items-center p-8',
      [
        div(
          classes: 'relative',
          [
            // Outer ring
            div(
              classes: '''
                w-12 h-12 rounded-full
                border-2 border-brand/20 dark:border-brand-dark/20
                border-t-brand dark:border-t-brand-light
                animate-spin
              ''',
              [],
            ),
            // Inner dot
            div(
              classes: '''
                absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2
                w-2 h-2 rounded-full
                bg-brand dark:bg-brand-light
                animate-pulse
              ''',
              [],
            ),
          ],
        ),
        // Loading text with fade animation
        div(
          classes: '''
            ml-4 text-sm font-medium
            text-gray-600 dark:text-gray-400
            animate-pulse
          ''',
          [text('Loading')],
        ),
      ],
    );
  }
}
