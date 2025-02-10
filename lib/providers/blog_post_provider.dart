import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../models/blog_post.dart';

final currentPostProvider = StateProvider<BlogPost?>((ref) => null);

final blogPostsProvider = StateProvider<List<BlogPost>>((ref) => []);
