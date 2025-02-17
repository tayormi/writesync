import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'dart:html';

final currentRouteProvider = Provider<String>((ref) {
  return window.location.pathname ?? '/';
});
