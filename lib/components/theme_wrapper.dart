import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class ThemeWrapper extends StatelessComponent {
  final List<Component> children;
  final String? classes;

  const ThemeWrapper({
    required this.children,
    this.classes,
  });

  @override
  Component build(BuildContext context) {
    return Builder(
      builder: (context) {
        return div(
          classes:
              'bg-white text-gray-900 dark:bg-gray-900 dark:text-white ${classes ?? ''}',
          children,
        );
      },
    );
  }
}
