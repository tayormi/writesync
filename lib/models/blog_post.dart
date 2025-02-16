import 'package:jaspr/jaspr.dart';

@immutable
abstract class BlogPost implements Component {
  String get title;
  String get slug;
  String get markdownContent;
  DateTime get publishedAt;
  List<String> get tags;
  String get description;
  String get author;
  String? get imageUrl;
  String? get authorImageUrl;
  Map<String, String> get metadata;
  String get content;

  String get metaDescription => description.isEmpty
      ? markdownContent.substring(
          0, markdownContent.length > 160 ? 160 : markdownContent.length)
      : description;

  String get canonicalUrl => '/blog/$slug';

  Component render(BuildContext context);
}
