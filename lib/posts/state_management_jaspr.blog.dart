// Generated code - do not modify by hand
// ignore_for_file: undefined_identifier, expected_identifier, invalid_reference_to_this, non_constant_identifier_names, constant_identifier_names, invalid_element_content

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_blog/models/blog_post.dart';
import 'package:jaspr_blog/posts/blog_post_registry.dart';

class BlogPostStateManagementJaspr extends Component implements BlogPost {
  const BlogPostStateManagementJaspr();
  
  @override
  Element createElement() => createElement();
  
  @override
  String get title => 'State Management in Jaspr with Riverpod';
  
  @override
  String get slug => 'state-management-jaspr';
  
  @override
  DateTime get publishedAt => DateTime.parse('2024-02-20');
  
  @override
  List<String> get tags => ['dart', 'jaspr', 'riverpod', 'state-management'];
  
  @override
  String get description => 'Learn how to effectively manage state in your Jaspr applications using Riverpod. Discover patterns and best practices for building scalable and maintainable web applications.';
  
  @override
  String get author => 'Jane Smith';
  
  @override
  String? get imageUrl => 'https://images.unsplash.com/photo-1555949963-ff9fe0c870eb';
  
  @override
  String? get authorImageUrl => null;
  
  @override
  Map<String, String> get metadata => {
    'author_image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330'
  };
  
  static final String _rawMarkdown = r"""# State Management in Jaspr with Riverpod

State management is a crucial aspect of any web application. In this post, we'll explore how to effectively manage state in Jaspr applications using Riverpod, a powerful state management solution for Dart.

## Why Riverpod?

Riverpod offers several advantages for state management in Jaspr:

1. **Type Safety**: Full type safety with no runtime exceptions
2. **Dependency Injection**: Simple and intuitive dependency injection
3. **Testing**: Easy to test and mock dependencies
4. **Code Organization**: Clear separation of concerns
5. **Reactivity**: Efficient updates and rebuilds

## Getting Started with Riverpod

First, add the required dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  jaspr_riverpod: ^latest_version
```

Then, wrap your app with a `ProviderScope`:

```dart
void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
```

## Creating Providers

Here are different types of providers you can use:

### Provider

For simple values that don't change:

```dart
final configProvider = Provider<AppConfig>((ref) {
  return AppConfig();
});
```

### StateProvider

For simple state that can change:

```dart
final counterProvider = StateProvider<int>((ref) => 0);
```

### StateNotifierProvider

For complex state management:

```dart
class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier() : super([]);

  void addTodo(Todo todo) {
    state = [...state, todo];
  }
}

final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  return TodosNotifier();
});
```

## Using Providers in Components

Here's how to use providers in your Jaspr components:

```dart
class TodoList extends StatelessComponent {
  @override
  Iterable<Component> build(BuildContext context) sync* {
    final todos = context.watch(todosProvider);
    
    yield div(
      classes: 'space-y-4',
      [
        for (final todo in todos)
          TodoItem(todo: todo),
      ],
    );
  }
}
```

## Advanced Patterns

### Combining Providers

You can create providers that depend on other providers:

```dart
final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todosProvider);
  final filter = ref.watch(filterProvider);
  
  return todos.where((todo) => filter.matches(todo)).toList();
});
```

### AsyncNotifierProvider

For handling async state:

```dart
class UserNotifier extends AsyncNotifier<User> {
  @override
  Future<User> build() async {
    return await fetchUser();
  }
}

final userProvider = AsyncNotifierProvider<UserNotifier, User>(() {
  return UserNotifier();
});
```

## Best Practices

1. **Keep Providers Small**: Each provider should have a single responsibility
2. **Use Proper Provider Types**: Choose the right provider for your use case
3. **Handle Loading States**: Always handle loading and error states
4. **Dispose Resources**: Clean up resources when they're no longer needed
5. **Test Your Providers**: Write unit tests for your providers

## Error Handling

Proper error handling is crucial. Here's an example:

```dart
class DataNotifier extends StateNotifier<AsyncValue<Data>> {
  DataNotifier() : super(const AsyncValue.loading()) {
    loadData();
  }

  Future<void> loadData() async {
    state = const AsyncValue.loading();
    try {
      final data = await fetchData();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
```

## Conclusion

Riverpod provides a powerful and flexible state management solution for Jaspr applications. By following these patterns and best practices, you can build maintainable and scalable web applications with confidence.

Remember to:
- Choose the right provider type for your needs
- Handle loading and error states
- Test your state management logic
- Keep your providers focused and maintainable

Stay tuned for more advanced topics on state management in Jaspr!""";
  
  @override
  String get markdownContent => _rawMarkdown;
  
  @override
  String get content => r"""<h1>State Management in Jaspr with Riverpod</h1>
<p>
State management is a crucial aspect of any web application. In this post, we\'ll explore how to effectively manage state in Jaspr applications using Riverpod, a powerful state management solution for Dart.</p>
<h2>Why Riverpod?</h2>
<p>
Riverpod offers several advantages for state management in Jaspr:</p>
<p>1. <strong>Type Safety</strong>: Full type safety with no runtime exceptions
2. <strong>Dependency Injection</strong>: Simple and intuitive dependency injection
3. <strong>Testing</strong>: Easy to test and mock dependencies
4. <strong>Code Organization</strong>: Clear separation of concerns
5. <strong>Reactivity</strong>: Efficient updates and rebuilds</p>
<h2>Getting Started with Riverpod</h2>
<p>
First, add the required dependencies to your <code>pubspec.yaml</code>:</p>
<pre><code class="language-yaml">dependencies:
  jaspr_riverpod: ^latest_version
</code></pre>
<p>
Then, wrap your app with a <code>ProviderScope</code>:</p>
<pre><code class="language-dart">void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
</code></pre>
<h2>Creating Providers</h2>
<p>
Here are different types of providers you can use:</p>
<h3>Provider</h3>
<p>
For simple values that don\'t change:</p>
<pre><code class="language-dart">final configProvider = Provider&lt;AppConfig&gt;((ref) {
  return AppConfig();
});
</code></pre>
<h3>StateProvider</h3>
<p>
For simple state that can change:</p>
<pre><code class="language-dart">final counterProvider = StateProvider&lt;int&gt;((ref) =&gt; 0);
</code></pre>
<h3>StateNotifierProvider</h3>
<p>
For complex state management:</p>
<pre><code class="language-dart">class TodosNotifier extends StateNotifier&lt;List&lt;Todo&gt;&gt; {
  TodosNotifier() : super([]);

  void addTodo(Todo todo) {
    state = [...state, todo];
  }
}

final todosProvider = StateNotifierProvider&lt;TodosNotifier, List&lt;Todo&gt;&gt;((ref) {
  return TodosNotifier();
});
</code></pre>
<h2>Using Providers in Components</h2>
<p>
Here\'s how to use providers in your Jaspr components:</p>
<pre><code class="language-dart">class TodoList extends StatelessComponent {
  @override
  Iterable&lt;Component&gt; build(BuildContext context) sync* {
    final todos = context.watch(todosProvider);
    
    yield div(
      classes: \'space-y-4\',
      [
        for (final todo in todos)
          TodoItem(todo: todo),
      ],
    );
  }
}
</code></pre>
<h2>Advanced Patterns</h2>
<h3>Combining Providers</h3>
<p>
You can create providers that depend on other providers:</p>
<pre><code class="language-dart">final filteredTodosProvider = Provider&lt;List&lt;Todo&gt;&gt;((ref) {
  final todos = ref.watch(todosProvider);
  final filter = ref.watch(filterProvider);
  
  return todos.where((todo) =&gt; filter.matches(todo)).toList();
});
</code></pre>
<h3>AsyncNotifierProvider</h3>
<p>
For handling async state:</p>
<pre><code class="language-dart">class UserNotifier extends AsyncNotifier&lt;User&gt; {
  @override
  Future&lt;User&gt; build() async {
    return await fetchUser();
  }
}

final userProvider = AsyncNotifierProvider&lt;UserNotifier, User&gt;(() {
  return UserNotifier();
});
</code></pre>
<h2>Best Practices</h2>
<p>1. <strong>Keep Providers Small</strong>: Each provider should have a single responsibility
2. <strong>Use Proper Provider Types</strong>: Choose the right provider for your use case
3. <strong>Handle Loading States</strong>: Always handle loading and error states
4. <strong>Dispose Resources</strong>: Clean up resources when they\'re no longer needed
5. <strong>Test Your Providers</strong>: Write unit tests for your providers</p>
<h2>Error Handling</h2>
<p>
Proper error handling is crucial. Here\'s an example:</p>
<pre><code class="language-dart">class DataNotifier extends StateNotifier&lt;AsyncValue&lt;Data&gt;&gt; {
  DataNotifier() : super(const AsyncValue.loading()) {
    loadData();
  }

  Future&lt;void&gt; loadData() async {
    state = const AsyncValue.loading();
    try {
      final data = await fetchData();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
</code></pre>
<h2>Conclusion</h2>
<p>
Riverpod provides a powerful and flexible state management solution for Jaspr applications. By following these patterns and best practices, you can build maintainable and scalable web applications with confidence.</p>
<p>
Remember to:</p>
<p>- Choose the right provider type for your needs</p>
<p>- Handle loading and error states</p>
<p>- Test your state management logic</p>
<p>- Keep your providers focused and maintainable</p>
<p>
Stay tuned for more advanced topics on state management in Jaspr!</p>""";
  
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
  String get canonicalUrl => '/blog/state-management-jaspr';
  
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
  registerPostFactory(() => const BlogPostStateManagementJaspr());
}
