// Generated code - do not modify by hand
// ignore_for_file: undefined_identifier, expected_identifier, invalid_reference_to_this, non_constant_identifier_names, constant_identifier_names, invalid_element_content

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_blog/models/blog_post.dart';
import 'package:jaspr_blog/posts/blog_post_registry.dart';

class BlogPostDartAsyncProgramming extends Component implements BlogPost {
  const BlogPostDartAsyncProgramming();
  
  @override
  Element createElement() => createElement();
  
  @override
  String get title => 'Mastering Async Programming in Dart';
  
  @override
  String get slug => 'dart-async-programming';
  
  @override
  DateTime get publishedAt => DateTime.parse('2024-01-30');
  
  @override
  List<String> get tags => ['dart', 'async', 'programming', 'tutorials'];
  
  @override
  String get description => 'Learn how to write efficient asynchronous code in Dart using Future, async/await, and Streams. Master error handling and best practices for concurrent programming.';
  
  @override
  String get author => 'Sarah Chen';
  
  @override
  String? get imageUrl => 'https://images.unsplash.com/photo-1629654297299-c8506221ca97';
  
  @override
  String? get authorImageUrl => null;
  
  @override
  Map<String, String> get metadata => {
    'author_image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
    'metadata': '{readTime: 8 min}'
  };
  
  static final String _rawMarkdown = r"""# Mastering Async Programming in Dart

Asynchronous programming is a crucial skill for modern developers. In this comprehensive guide, we'll explore how Dart handles async operations and how you can write better concurrent code.

## Understanding Futures

A `Future` represents a value that will be available at some point in the future. Here's a simple example:

```dart
Future<String> fetchUserData() async {
  // Simulate network delay
  await Future.delayed(Duration(seconds: 2));
  return 'User Data';
}

void main() async {
  print('Fetching data...');
  final data = await fetchUserData();
  print('Data received: $data');
}
```

## Working with Streams

Streams are perfect for handling sequences of asynchronous events. Here's how you can use them:

```dart
Stream<int> countDown(int from) async* {
  for (int i = from; i >= 0; i--) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}

void main() async {
  await for (final number in countDown(5)) {
    print(number);
  }
  print('Blast off! 🚀');
}
```

## Error Handling

Always handle errors in async code properly:

```dart
Future<void> riskyOperation() async {
  try {
    await Future.error('Something went wrong');
  } catch (e) {
    print('Error caught: $e');
  }
}
```

## Best Practices

1. Always use `async/await` over `.then()` for better readability
2. Handle errors appropriately using try-catch
3. Cancel streams when they're no longer needed
4. Use `Future.wait` for parallel operations
5. Consider using `StreamController` for custom streams

## Conclusion

Mastering async programming in Dart opens up possibilities for building responsive and efficient applications. Practice these concepts, and you'll be writing better async code in no time!""";
  
  @override
  String get markdownContent => _rawMarkdown;
  
  @override
  String get content => r"""<h1>Mastering Async Programming in Dart</h1>
<p>
Asynchronous programming is a crucial skill for modern developers. In this comprehensive guide, we\'ll explore how Dart handles async operations and how you can write better concurrent code.</p>
<h2>Understanding Futures</h2>
<p>
A <code>Future</code> represents a value that will be available at some point in the future. Here\'s a simple example:</p>
<pre><code class="language-dart">Future&lt;String&gt; fetchUserData() async {
  // Simulate network delay
  await Future.delayed(Duration(seconds: 2));
  return \'User Data\';
}

void main() async {
  print(\'Fetching data...\');
  final data = await fetchUserData();
  print(\'Data received: $data\');
}
</code></pre>
<h2>Working with Streams</h2>
<p>
Streams are perfect for handling sequences of asynchronous events. Here\'s how you can use them:</p>
<pre><code class="language-dart">Stream&lt;int&gt; countDown(int from) async* {
  for (int i = from; i &gt;= 0; i--) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}

void main() async {
  await for (final number in countDown(5)) {
    print(number);
  }
  print(\'Blast off! 🚀\');
}
</code></pre>
<h2>Error Handling</h2>
<p>
Always handle errors in async code properly:</p>
<pre><code class="language-dart">Future&lt;void&gt; riskyOperation() async {
  try {
    await Future.error(\'Something went wrong\');
  } catch (e) {
    print(\'Error caught: $e\');
  }
}
</code></pre>
<h2>Best Practices</h2>
<p>1. Always use <code>async/await</code> over <code>.then()</code> for better readability
2. Handle errors appropriately using try-catch
3. Cancel streams when they\'re no longer needed
4. Use <code>Future.wait</code> for parallel operations
5. Consider using <code>StreamController</code> for custom streams</p>
<h2>Conclusion</h2>
<p>
Mastering async programming in Dart opens up possibilities for building responsive and efficient applications. Practice these concepts, and you\'ll be writing better async code in no time!</p>""";
  
  @override
  Component render(BuildContext context) {
    return div(
      id: slug,
      classes: 'blog-post',
      [
        div(
          classes: 'prose prose-lg mx-auto prose-img:rounded-xl prose-headings:font-semibold',
          attributes: {
            'innerHTML': content,
          },
          [],
        ),
      ],
    );
  }
  
  @override
  String get canonicalUrl => '/blog/dart-async-programming';
  
  @override
  String get metaDescription => description.isEmpty
      ? markdownContent.substring(
          0, markdownContent.length > 160 ? 160 : markdownContent.length)
      : description;
  
  @override
  Key? get key => null;
}

// Register this blog post with the registry
void registerBlogPost() {
  registerPostFactory(() => const BlogPostDartAsyncProgramming());
}
