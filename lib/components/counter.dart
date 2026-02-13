import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';


class Counter extends StatefulComponent {
  const Counter({super.key});

  @override
  State<Counter> createState() => CounterState();
}

class CounterState extends State<Counter> {
  int count = 0;

  @override
  Component build(BuildContext context) {
    return div(classes: 'counter', [
      button(
        onClick: () {
          setState(() => count--);
        },
        [Component.text('-')],
      ),
      span([Component.text('$count')]),
      button(
        onClick: () {
          setState(() => count++);
        },
        [Component.text('+')],
      ),
    ]);
  }
}
