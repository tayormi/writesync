import 'package:jaspr_riverpod/legacy.dart';
import '../models/blog_post.dart';

final currentPostProvider = StateProvider<BlogPost?>((ref) => null);

final blogPostsProvider = StateProvider<List<BlogPost>>((ref) => []);
