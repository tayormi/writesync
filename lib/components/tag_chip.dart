import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'dart:html' as html;
import '../providers/tag_provider.dart';

class TagChip extends StatelessComponent {
  final String tag;
  final bool isSelected;

  const TagChip({
    required this.tag,
    this.isSelected = false,
  });

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield a(
      href: '/tag/$tag',
      classes: [
        'inline-flex items-center px-3 py-1 rounded-full text-sm',
        'transition-colors duration-200',
        if (isSelected)
          'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200'
        else
          'bg-gray-100 text-gray-700 hover:bg-gray-200 dark:bg-gray-800 dark:text-gray-300 dark:hover:bg-gray-700'
      ].join(' '),
      events: {
        'click': (event) {
          event.preventDefault();
          context.read(selectedTagProvider.notifier).state = tag;
          html.window.history.pushState(null, '', '/tag/$tag');
        }
      },
      [
        text('#$tag'),
      ],
    );
  }
}
