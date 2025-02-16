// Generated code - do not modify by hand
// ignore_for_file: undefined_identifier, expected_identifier, invalid_reference_to_this, non_constant_identifier_names, constant_identifier_names, invalid_element_content

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_blog/models/blog_post.dart';
import 'package:jaspr_blog/posts/blog_post_registry.dart';

class BlogPostAdvancedDartPatterns extends Component implements BlogPost {
  const BlogPostAdvancedDartPatterns();
  
  @override
  Element createElement() => createElement();
  
  @override
  String get title => 'Advanced Dart Design Patterns';
  
  @override
  String get slug => 'advanced-dart-patterns';
  
  @override
  DateTime get publishedAt => DateTime.parse('2024-02-02');
  
  @override
  List<String> get tags => ['dart', 'patterns', 'architecture', 'advanced'];
  
  @override
  String get description => 'Deep dive into advanced design patterns in Dart, with practical examples and best practices';
  
  @override
  String get author => 'Jane Smith';
  
  @override
  String? get imageUrl => 'https://images.unsplash.com/photo-1555066931-4365d14bab8c';
  
  @override
  String? get authorImageUrl => null;
  
  @override
  Map<String, String> get metadata => {
    'author_image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
    'metadata': '{readTime: 15 min}'
  };
  
  static final String _rawMarkdown = r"""# Advanced Dart Design Patterns

Design patterns are reusable solutions to common problems in software design. Let's explore some advanced patterns in Dart.

## Factory Pattern

The Factory pattern provides an interface for creating objects without exposing the instantiation logic.

```dart
abstract class Animal {
  String makeSound();
}

class Dog implements Animal {
  @override
  String makeSound() => 'Woof!';
}

class Cat implements Animal {
  @override
  String makeSound() => 'Meow!';
}

class AnimalFactory {
  static Animal createAnimal(String type) {
    switch (type.toLowerCase()) {
      case 'dog':
        return Dog();
      case 'cat':
        return Cat();
      default:
        throw ArgumentError('Unknown animal type');
    }
  }
}
```

## Singleton Pattern

Ensure a class has only one instance and provide a global point of access to it.

```dart
class DatabaseConnection {
  static final DatabaseConnection _instance = DatabaseConnection._internal();
  
  // Private constructor
  DatabaseConnection._internal();
  
  // Factory constructor
  factory DatabaseConnection() {
    return _instance;
  }
  
  Future<void> query(String sql) async {
    // Database query implementation
  }
}
```

## Observer Pattern

Define a one-to-many dependency between objects where a state change in one object results in all its dependents being notified and updated automatically.

```dart
abstract class Subject {
  void attach(Observer observer);
  void detach(Observer observer);
  void notify();
}

abstract class Observer {
  void update(String message);
}

class NewsAgency implements Subject {
  final List<Observer> _observers = [];
  String _news = '';

  void attach(Observer observer) => _observers.add(observer);
  void detach(Observer observer) => _observers.remove(observer);
  
  void notify() {
    for (var observer in _observers) {
      observer.update(_news);
    }
  }

  set news(String value) {
    _news = value;
    notify();
  }
}

class NewsChannel implements Observer {
  final String name;
  
  NewsChannel(this.name);

  @override
  void update(String news) {
    print('$name received news: $news');
  }
}
```

## Pattern Comparison

| Pattern | Purpose | Complexity | Use Case |
|---------|---------|------------|----------|
| Factory | Object creation | Low | When object creation logic should be centralized |
| Singleton | Single instance | Low | Database connections, Configuration |
| Observer | Event handling | Medium | UI updates, Event systems |
| Builder | Complex object construction | Medium | Objects with many optional parameters |
| Strategy | Algorithm encapsulation | Medium | Different algorithms at runtime |

## Implementation Flow

```mermaid
graph TD
    A[Client Code] --> B{Factory Pattern}
    B -->|Create| C[Product A]
    B -->|Create| D[Product B]
    E[Observer] --> F{Subject}
    F -->|Notify| G[Observer 1]
    F -->|Notify| H[Observer 2]
    I[Singleton] --> J[Single Instance]
```

## Best Practices

1. **SOLID Principles**
   ```dart
   // Single Responsibility Principle
   class UserRepository {
     final Database _db;
     
     UserRepository(this._db);
     
     Future<User> getUser(String id) async {
       // Database logic only
       return _db.query('users', id);
     }
   }
   ```

2. **Dependency Injection**
   ```dart
   class UserService {
     final UserRepository _repository;
     final AuthService _auth;
     
     UserService(this._repository, this._auth);
     
     Future<User> getCurrentUser() async {
       final userId = _auth.currentUserId;
       return _repository.getUser(userId);
     }
   }
   ```

## Performance Considerations

Here's a comparison of different pattern implementations:

| Implementation | Memory Usage | CPU Usage | Initialization Time |
|----------------|--------------|-----------|-------------------|
| Lazy Singleton | Low | Low | On-demand |
| Eager Singleton | Medium | Low | At startup |
| Factory Method | Low | Medium | Per instance |
| Abstract Factory | Medium | Medium | Per family |

## Code Organization

```
lib/
├── src/
│   ├── patterns/
│   │   ├── factory.dart
│   │   ├── singleton.dart
│   │   └── observer.dart
│   ├── models/
│   │   └── user.dart
│   └── services/
│       └── database.dart
└── main.dart
```

## Advanced Example: Combined Patterns

Here's an example combining multiple patterns:

```dart
// Singleton Service Locator with Factory Pattern
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  final _factories = <Type, Object Function()>{};
  final _singletons = <Type, Object>{};

  void registerFactory<T>(T Function() factory) {
    _factories[T] = factory;
  }

  void registerSingleton<T>(T instance) {
    _singletons[T] = instance;
  }

  T get<T>() {
    if (_singletons.containsKey(T)) {
      return _singletons[T] as T;
    }
    
    if (_factories.containsKey(T)) {
      return _factories[T]!() as T;
    }
    
    throw Exception('No registration found for type $T');
  }
}
```

## Conclusion

Design patterns are essential tools in a developer's toolkit. Choose patterns based on your specific needs and remember that sometimes simpler solutions are better than complex patterns.

## References

1. "Design Patterns: Elements of Reusable Object-Oriented Software"
2. [Dart Design Patterns](https://dart.dev/guides/language/effective-dart)
3. [Flutter Architecture Samples](https://fluttersamples.com)""";
  
  @override
  String get markdownContent => _rawMarkdown;
  
  @override
  String get content => r"""<h1>Advanced Dart Design Patterns</h1>
<p>
Design patterns are reusable solutions to common problems in software design. Let\'s explore some advanced patterns in Dart.</p>
<h2>Factory Pattern</h2>
<p>
The Factory pattern provides an interface for creating objects without exposing the instantiation logic.</p>
<pre><code class="language-dart">abstract class Animal {
  String makeSound();
}

class Dog implements Animal {
  @override
  String makeSound() =&gt; \'Woof!\';
}

class Cat implements Animal {
  @override
  String makeSound() =&gt; \'Meow!\';
}

class AnimalFactory {
  static Animal createAnimal(String type) {
    switch (type.toLowerCase()) {
      case \'dog\':
        return Dog();
      case \'cat\':
        return Cat();
      default:
        throw ArgumentError(\'Unknown animal type\');
    }
  }
}
</code></pre>
<h2>Singleton Pattern</h2>
<p>
Ensure a class has only one instance and provide a global point of access to it.</p>
<pre><code class="language-dart">class DatabaseConnection {
  static final DatabaseConnection _instance = DatabaseConnection._internal();
  
  // Private constructor
  DatabaseConnection._internal();
  
  // Factory constructor
  factory DatabaseConnection() {
    return _instance;
  }
  
  Future&lt;void&gt; query(String sql) async {
    // Database query implementation
  }
}
</code></pre>
<h2>Observer Pattern</h2>
<p>
Define a one-to-many dependency between objects where a state change in one object results in all its dependents being notified and updated automatically.</p>
<pre><code class="language-dart">abstract class Subject {
  void attach(Observer observer);
  void detach(Observer observer);
  void notify();
}

abstract class Observer {
  void update(String message);
}

class NewsAgency implements Subject {
  final List&lt;Observer&gt; _observers = [];
  String _news = \'\';

  void attach(Observer observer) =&gt; _observers.add(observer);
  void detach(Observer observer) =&gt; _observers.remove(observer);
  
  void notify() {
    for (var observer in _observers) {
      observer.update(_news);
    }
  }

  set news(String value) {
    _news = value;
    notify();
  }
}

class NewsChannel implements Observer {
  final String name;
  
  NewsChannel(this.name);

  @override
  void update(String news) {
    print(\'$name received news: $news\');
  }
}
</code></pre>
<h2>Pattern Comparison</h2>
<table>
<thead>
<tr>
<th>Pattern</th>
<th>Purpose</th>
<th>Complexity</th>
<th>Use Case</th>
</tr>
</thead>
<tbody>
<tr>
<td>Factory</td>
<td>Object creation</td>
<td>Low</td>
<td>When object creation logic should be centralized</td>
</tr>
<tr>
<td>Singleton</td>
<td>Single instance</td>
<td>Low</td>
<td>Database connections, Configuration</td>
</tr>
<tr>
<td>Observer</td>
<td>Event handling</td>
<td>Medium</td>
<td>UI updates, Event systems</td>
</tr>
<tr>
<td>Builder</td>
<td>Complex object construction</td>
<td>Medium</td>
<td>Objects with many optional parameters</td>
</tr>
<tr>
<td>Strategy</td>
<td>Algorithm encapsulation</td>
<td>Medium</td>
<td>Different algorithms at runtime</td>
</tr>
</tbody>
</table>
<h2>Implementation Flow</h2>
<pre><code class="language-mermaid">graph TD
    A[Client Code] --&gt; B{Factory Pattern}
    B --&gt;|Create| C[Product A]
    B --&gt;|Create| D[Product B]
    E[Observer] --&gt; F{Subject}
    F --&gt;|Notify| G[Observer 1]
    F --&gt;|Notify| H[Observer 2]
    I[Singleton] --&gt; J[Single Instance]
</code></pre>
<h2>Best Practices</h2>
<p>1. <strong>SOLID Principles</strong></p>
<pre><code class="language-dart">// Single Responsibility Principle
class UserRepository {
  final Database _db;
  
  UserRepository(this._db);
  
  Future&lt;User&gt; getUser(String id) async {
    // Database logic only
    return _db.query(\'users\', id);
  }
}
</code></pre>
<p>
2. <strong>Dependency Injection</strong></p>
<pre><code class="language-dart">class UserService {
  final UserRepository _repository;
  final AuthService _auth;
  
  UserService(this._repository, this._auth);
  
  Future&lt;User&gt; getCurrentUser() async {
    final userId = _auth.currentUserId;
    return _repository.getUser(userId);
  }
}
</code></pre>
<h2>Performance Considerations</h2>
<p>
Here\'s a comparison of different pattern implementations:</p>
<table>
<thead>
<tr>
<th>Implementation</th>
<th>Memory Usage</th>
<th>CPU Usage</th>
<th>Initialization Time</th>
</tr>
</thead>
<tbody>
<tr>
<td>Lazy Singleton</td>
<td>Low</td>
<td>Low</td>
<td>On-demand</td>
</tr>
<tr>
<td>Eager Singleton</td>
<td>Medium</td>
<td>Low</td>
<td>At startup</td>
</tr>
<tr>
<td>Factory Method</td>
<td>Low</td>
<td>Medium</td>
<td>Per instance</td>
</tr>
<tr>
<td>Abstract Factory</td>
<td>Medium</td>
<td>Medium</td>
<td>Per family</td>
</tr>
</tbody>
</table>
<h2>Code Organization</h2>
<pre><code>lib/
├── src/
│   ├── patterns/
│   │   ├── factory.dart
│   │   ├── singleton.dart
│   │   └── observer.dart
│   ├── models/
│   │   └── user.dart
│   └── services/
│       └── database.dart
└── main.dart
</code></pre>
<h2>Advanced Example: Combined Patterns</h2>
<p>
Here\'s an example combining multiple patterns:</p>
<pre><code class="language-dart">// Singleton Service Locator with Factory Pattern
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() =&gt; _instance;
  ServiceLocator._internal();

  final _factories = &lt;Type, Object Function()&gt;{};
  final _singletons = &lt;Type, Object&gt;{};

  void registerFactory&lt;T&gt;(T Function() factory) {
    _factories[T] = factory;
  }

  void registerSingleton&lt;T&gt;(T instance) {
    _singletons[T] = instance;
  }

  T get&lt;T&gt;() {
    if (_singletons.containsKey(T)) {
      return _singletons[T] as T;
    }
    
    if (_factories.containsKey(T)) {
      return _factories[T]!() as T;
    }
    
    throw Exception(\'No registration found for type $T\');
  }
}
</code></pre>
<h2>Conclusion</h2>
<p>
Design patterns are essential tools in a developer\'s toolkit. Choose patterns based on your specific needs and remember that sometimes simpler solutions are better than complex patterns.</p>
<h2>References</h2>
<p>1. &quot;Design Patterns: Elements of Reusable Object-Oriented Software&quot;
2. <a href="https://dart.dev/guides/language/effective-dart">Dart Design Patterns</a>
3. <a href="https://fluttersamples.com">Flutter Architecture Samples</a></p>""";
  
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
  String get canonicalUrl => '/blog/advanced-dart-patterns';
  
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
  registerPostFactory(() => const BlogPostAdvancedDartPatterns());
}
