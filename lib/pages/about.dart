import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class About extends StatelessComponent {
  const About({super.key});

  @override
  Component build(BuildContext context) {
    return section([
      ol([
        li([
          h3([Component.text('📖 Documentation')]),
          Component.text('Jaspr\'s '),
          a(href: 'https://docs.page/schultek/jaspr', [Component.text('official documentation')]),
          Component.text(' provides you with all information you need to get started.'),
        ]),
        li([
          h3([Component.text('💬 Community')]),
          Component.text('Got stuck? Ask your question on the official '),
          a(href: 'https://docs.page/schultek/jaspr', [Component.text('Discord server')]),
          Component.text(' for the Jaspr community.'),
        ]),
        li([
          h3([Component.text('📦 Ecosystem')]),
          Component.text(
              'Get official packages and integrations for your project like jaspr_router, jaspr_tailwind or jaspr_riverpod. Find packages built for Jaspr on pub.dev using the '),
          a(href: 'https://pub.dev/packages?q=topic%3Ajaspr', [Component.text('#jaspr')]),
          Component.text(' topic, or publish your own.'),
        ]),
        li([
          h3([Component.text('💙 Support Jaspr')]),
          Component.text('If you like Jaspr, consider starring us on '),
          a(href: 'https://github.com/schultek/jaspr', [Component.text('Github')]),
          Component.text(' and tell your friends.'),
        ]),
      ]),
    ]);
  }
}
