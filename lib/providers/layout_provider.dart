import 'package:jaspr_riverpod/jaspr_riverpod.dart';

enum BlogLayout {
  grid,
  list,
}

final blogLayoutProvider = StateProvider<BlogLayout>((ref) => BlogLayout.grid);
