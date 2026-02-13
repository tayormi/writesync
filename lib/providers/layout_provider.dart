import 'package:jaspr_riverpod/legacy.dart';

enum BlogLayout {
  grid,
  list,
}

final blogLayoutProvider = StateProvider<BlogLayout>((ref) => BlogLayout.grid);
