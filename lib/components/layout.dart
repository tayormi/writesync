import 'package:jaspr/jaspr.dart';
import 'theme_wrapper.dart';
import 'header.dart';
import 'footer.dart';

class Layout extends StatelessComponent {
  final List<Component> children;

  const Layout({required this.children});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield ThemeWrapper(
      children: [
        div(
          classes: 'min-h-screen flex flex-col bg-white dark:bg-gray-900',
          [
            Header(),
            DomComponent(
              tag: 'main',
              classes: 'flex-grow w-full',
              children: children,
            ),
            Footer(),
          ],
        ),
      ],
    );
  }
}
