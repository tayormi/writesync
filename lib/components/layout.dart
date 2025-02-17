import 'package:jaspr/jaspr.dart';
import 'theme_wrapper.dart';
import 'header.dart';
import 'footer.dart';
import 'page_background.dart';

class Layout extends StatelessComponent {
  final List<Component> children;
  final bool withGradient;

  const Layout({
    required this.children,
    this.withGradient = true,
  });

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield ThemeWrapper(
      children: [
        PageBackground(
          withGradient: withGradient,
          children: [
            div(
              classes: 'min-h-screen flex flex-col bg-transparent',
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
        ),
      ],
    );
  }
}
