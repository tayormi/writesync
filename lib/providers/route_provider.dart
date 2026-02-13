import 'package:jaspr_riverpod/jaspr_riverpod.dart';
// ignore_for_file: deprecated_member_use

import 'dart:html';

final currentRouteProvider = Provider<String>((ref) {
  return window.location.pathname ?? '/';
});
