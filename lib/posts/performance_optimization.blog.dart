// Generated code - do not modify by hand
// ignore_for_file: undefined_identifier, expected_identifier, invalid_reference_to_this, non_constant_identifier_names, constant_identifier_names, invalid_element_content

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_blog/models/blog_post.dart';
import 'package:jaspr_blog/posts/blog_post_registry.dart';

class BlogPostPerformanceOptimization extends Component implements BlogPost {
  const BlogPostPerformanceOptimization();
  
  @override
  Element createElement() => createElement();
  
  @override
  String get title => 'Performance Optimization Techniques for Jaspr Apps';
  
  @override
  String get slug => 'performance_optimization';
  
  @override
  DateTime get publishedAt => DateTime.parse('2024-03-19');
  
  @override
  List<String> get tags => ['performance', 'optimization', 'jaspr', 'web'];
  
  @override
  String get description => 'Learn advanced techniques for optimizing your Jaspr applications, from code splitting to efficient state management and rendering optimizations.';
  
  @override
  String get author => 'Michael Rodriguez';
  
  @override
  String? get imageUrl => 'https://images.unsplash.com/photo-1551288049-bebda4e38f71';
  
  @override
  String? get authorImageUrl => 'https://images.unsplash.com/photo-1568602471122-7832951cc4c5';
  
  @override
  Map<String, String> get metadata => {
    
  };
  
  static final String _rawMarkdown = r"""# Performance Optimization Techniques for Jaspr Apps

Performance is crucial for web applications. In this guide, we'll explore various techniques to optimize your Jaspr applications for better speed and user experience.

## Understanding Performance Metrics

Key performance metrics to monitor:

1. **First Contentful Paint (FCP)**
2. **Largest Contentful Paint (LCP)**
3. **Time to Interactive (TTI)**
4. **First Input Delay (FID)**
5. **Cumulative Layout Shift (CLS)**

## Code Splitting

Implement code splitting to reduce initial bundle size:

```dart
// Lazy load components
final lazyComponent = Component.lazy(() async {
  await Future.delayed(Duration(milliseconds: 100));
  return HeavyComponent();
});

// Usage in your component
div([
  Suspense(
    fallback: LoadingSpinner(),
    child: lazyComponent,
  ),
])
```

## Efficient State Management

Optimize state management to prevent unnecessary renders:

```dart
@riverpod
class FilteredItems extends _$FilteredItems {
  @override
  List<Item> build(List<String> tags) {
    final items = ref.watch(itemsProvider);
    
    // Memoize filtered results
    return items.where((item) => 
      tags.isEmpty || item.tags.any((tag) => tags.contains(tag))
    ).toList();
  }
}

// Usage in component
class ItemList extends StatelessComponent {
  @override
  Iterable<Component> build(BuildContext context) sync* {
    final items = context.watch(filteredItemsProvider);
    
    yield div(
      classes: 'grid gap-4',
      [
        for (final item in items)
          ItemCard(item: item),
      ],
    );
  }
}
```

## Virtual Scrolling

Implement virtual scrolling for long lists:

```dart
class VirtualList extends StatefulComponent {
  final List<Item> items;
  final double itemHeight;
  
  VirtualList({
    required this.items,
    this.itemHeight = 50,
  });
  
  @override
  State<VirtualList> createState() => _VirtualListState();
}

class _VirtualListState extends State<VirtualList> {
  int _startIndex = 0;
  int _visibleItems = 10;
  
  @override
  Iterable<Component> build(BuildContext context) sync* {
    final visibleItems = component.items
      .skip(_startIndex)
      .take(_visibleItems);
      
    yield div(
      classes: 'relative',
      attributes: {
        'style': 'height: ${component.items.length * component.itemHeight}px',
      },
      [
        div(
          attributes: {
            'style': 'transform: translateY(${_startIndex * component.itemHeight}px)',
          },
          [
            for (final item in visibleItems)
              ItemComponent(item: item),
          ],
        ),
      ],
    );
  }
}
```

## Image Optimization

Optimize images for better performance:

```dart
img(
  src: 'image.jpg',
  classes: '''
    w-full h-64 object-cover
    blur-up lazyload
  ''',
  attributes: {
    'loading': 'lazy',
    'srcset': '''
      image-400.jpg 400w,
      image-800.jpg 800w,
      image-1200.jpg 1200w
    ''',
    'sizes': '(max-width: 400px) 100vw, 50vw',
    'data-src': 'image-full.jpg',
  },
)
```

## Caching Strategies

Implement effective caching:

```dart
class CacheService {
  static final _instance = CacheService._();
  factory CacheService() => _instance;
  CacheService._();
  
  final _cache = <String, dynamic>{};
  
  T? get<T>(String key) => _cache[key] as T?;
  
  void set<T>(String key, T value) {
    _cache[key] = value;
  }
  
  Future<T> getOrFetch<T>(
    String key,
    Future<T> Function() fetch,
  ) async {
    if (_cache.containsKey(key)) {
      return _cache[key] as T;
    }
    
    final value = await fetch();
    _cache[key] = value;
    return value;
  }
}
```

## Component Optimization

Optimize component rendering:

```dart
class OptimizedList extends StatelessComponent {
  final List<Item> items;
  
  const OptimizedList({required this.items});
  
  @override
  bool shouldComponentUpdate(OptimizedList oldComponent) {
    return !ListEquality().equals(items, oldComponent.items);
  }
  
  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div(
      [
        for (final item in items)
          // Use const constructor for child components
          const ItemComponent(),
      ],
    );
  }
}
```

## Memory Management

Implement proper memory management:

```dart
class DisposableComponent extends StatefulComponent {
  @override
  State<DisposableComponent> createState() => _DisposableComponentState();
}

class _DisposableComponentState extends State<DisposableComponent> {
  StreamSubscription? _subscription;
  
  @override
  void initState() {
    super.initState();
    _subscription = stream.listen((_) {});
  }
  
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
  
  @override
  Iterable<Component> build(BuildContext context) sync* {
    // Component implementation
  }
}
```

## Build Configuration

Optimize your build configuration:

```yaml
# build.yaml
targets:
  $default:
    builders:
      build_web_compilers|entrypoint:
        options:
          compiler: dart2js
          dart2js_args:
            - -O4
            - --minify
            - --trust-primitives
            - --trust-type-annotations
```

## Performance Monitoring

Implement performance monitoring:

```dart
class PerformanceMonitor {
  static void logMetric(String name, double value) {
    // Log to analytics service
    print('Performance metric: $name = $value');
  }
  
  static void measureOperation(
    String name,
    Future<void> Function() operation,
  ) async {
    final startTime = DateTime.now();
    await operation();
    final duration = DateTime.now().difference(startTime);
    
    logMetric(name, duration.inMilliseconds.toDouble());
  }
}
```

## Best Practices

1. **Component Design**
   - Keep components small and focused
   - Use const constructors where possible
   - Implement shouldComponentUpdate

2. **State Management**
   - Minimize state updates
   - Use appropriate state scoping
   - Implement efficient selectors

3. **Resource Loading**
   - Implement lazy loading
   - Optimize asset delivery
   - Use appropriate caching strategies

## Tools and Resources

1. [Web Vitals](https://web.dev/vitals/)
2. [Chrome DevTools Performance Panel](https://developers.google.com/web/tools/chrome-devtools/performance)
3. [Lighthouse](https://developers.google.com/web/tools/lighthouse)
4. [WebPageTest](https://www.webpagetest.org/)""";
  
  @override
  String get markdownContent => _rawMarkdown;
  
  @override
  String get content => r"""<h1>Performance Optimization Techniques for Jaspr Apps</h1>
<p>
Performance is crucial for web applications. In this guide, we\'ll explore various techniques to optimize your Jaspr applications for better speed and user experience.</p>
<h2>Understanding Performance Metrics</h2>
<p>
Key performance metrics to monitor:</p>
<p>1. <strong>First Contentful Paint (FCP)</strong>
2. <strong>Largest Contentful Paint (LCP)</strong>
3. <strong>Time to Interactive (TTI)</strong>
4. <strong>First Input Delay (FID)</strong>
5. <strong>Cumulative Layout Shift (CLS)</strong></p>
<h2>Code Splitting</h2>
<p>
Implement code splitting to reduce initial bundle size:</p>
<pre><code class="language-dart">// Lazy load components
final lazyComponent = Component.lazy(() async {
  await Future.delayed(Duration(milliseconds: 100));
  return HeavyComponent();
});

// Usage in your component
div([
  Suspense(
    fallback: LoadingSpinner(),
    child: lazyComponent,
  ),
])
</code></pre>
<h2>Efficient State Management</h2>
<p>
Optimize state management to prevent unnecessary renders:</p>
<pre><code class="language-dart">@riverpod
class FilteredItems extends _$FilteredItems {
  @override
  List&lt;Item&gt; build(List&lt;String&gt; tags) {
    final items = ref.watch(itemsProvider);
    
    // Memoize filtered results
    return items.where((item) =&gt; 
      tags.isEmpty || item.tags.any((tag) =&gt; tags.contains(tag))
    ).toList();
  }
}

// Usage in component
class ItemList extends StatelessComponent {
  @override
  Iterable&lt;Component&gt; build(BuildContext context) sync* {
    final items = context.watch(filteredItemsProvider);
    
    yield div(
      classes: \'grid gap-4\',
      [
        for (final item in items)
          ItemCard(item: item),
      ],
    );
  }
}
</code></pre>
<h2>Virtual Scrolling</h2>
<p>
Implement virtual scrolling for long lists:</p>
<pre><code class="language-dart">class VirtualList extends StatefulComponent {
  final List&lt;Item&gt; items;
  final double itemHeight;
  
  VirtualList({
    required this.items,
    this.itemHeight = 50,
  });
  
  @override
  State&lt;VirtualList&gt; createState() =&gt; _VirtualListState();
}

class _VirtualListState extends State&lt;VirtualList&gt; {
  int _startIndex = 0;
  int _visibleItems = 10;
  
  @override
  Iterable&lt;Component&gt; build(BuildContext context) sync* {
    final visibleItems = component.items
      .skip(_startIndex)
      .take(_visibleItems);
      
    yield div(
      classes: \'relative\',
      attributes: {
        \'style\': \'height: ${component.items.length * component.itemHeight}px\',
      },
      [
        div(
          attributes: {
            \'style\': \'transform: translateY(${_startIndex * component.itemHeight}px)\',
          },
          [
            for (final item in visibleItems)
              ItemComponent(item: item),
          ],
        ),
      ],
    );
  }
}
</code></pre>
<h2>Image Optimization</h2>
<p>
Optimize images for better performance:</p>
<pre><code class="language-dart">img(
  src: \'image.jpg\',
  classes: \'\'\'
    w-full h-64 object-cover
    blur-up lazyload
  \'\'\',
  attributes: {
    \'loading\': \'lazy\',
    \'srcset\': \'\'\'
      image-400.jpg 400w,
      image-800.jpg 800w,
      image-1200.jpg 1200w
    \'\'\',
    \'sizes\': \'(max-width: 400px) 100vw, 50vw\',
    \'data-src\': \'image-full.jpg\',
  },
)
</code></pre>
<h2>Caching Strategies</h2>
<p>
Implement effective caching:</p>
<pre><code class="language-dart">class CacheService {
  static final _instance = CacheService._();
  factory CacheService() =&gt; _instance;
  CacheService._();
  
  final _cache = &lt;String, dynamic&gt;{};
  
  T? get&lt;T&gt;(String key) =&gt; _cache[key] as T?;
  
  void set&lt;T&gt;(String key, T value) {
    _cache[key] = value;
  }
  
  Future&lt;T&gt; getOrFetch&lt;T&gt;(
    String key,
    Future&lt;T&gt; Function() fetch,
  ) async {
    if (_cache.containsKey(key)) {
      return _cache[key] as T;
    }
    
    final value = await fetch();
    _cache[key] = value;
    return value;
  }
}
</code></pre>
<h2>Component Optimization</h2>
<p>
Optimize component rendering:</p>
<pre><code class="language-dart">class OptimizedList extends StatelessComponent {
  final List&lt;Item&gt; items;
  
  const OptimizedList({required this.items});
  
  @override
  bool shouldComponentUpdate(OptimizedList oldComponent) {
    return !ListEquality().equals(items, oldComponent.items);
  }
  
  @override
  Iterable&lt;Component&gt; build(BuildContext context) sync* {
    yield div(
      [
        for (final item in items)
          // Use const constructor for child components
          const ItemComponent(),
      ],
    );
  }
}
</code></pre>
<h2>Memory Management</h2>
<p>
Implement proper memory management:</p>
<pre><code class="language-dart">class DisposableComponent extends StatefulComponent {
  @override
  State&lt;DisposableComponent&gt; createState() =&gt; _DisposableComponentState();
}

class _DisposableComponentState extends State&lt;DisposableComponent&gt; {
  StreamSubscription? _subscription;
  
  @override
  void initState() {
    super.initState();
    _subscription = stream.listen((_) {});
  }
  
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
  
  @override
  Iterable&lt;Component&gt; build(BuildContext context) sync* {
    // Component implementation
  }
}
</code></pre>
<h2>Build Configuration</h2>
<p>
Optimize your build configuration:</p>
<pre><code class="language-yaml"># build.yaml
targets:
  $default:
    builders:
      build_web_compilers|entrypoint:
        options:
          compiler: dart2js
          dart2js_args:
            - -O4
            - --minify
            - --trust-primitives
            - --trust-type-annotations
</code></pre>
<h2>Performance Monitoring</h2>
<p>
Implement performance monitoring:</p>
<pre><code class="language-dart">class PerformanceMonitor {
  static void logMetric(String name, double value) {
    // Log to analytics service
    print(\'Performance metric: $name = $value\');
  }
  
  static void measureOperation(
    String name,
    Future&lt;void&gt; Function() operation,
  ) async {
    final startTime = DateTime.now();
    await operation();
    final duration = DateTime.now().difference(startTime);
    
    logMetric(name, duration.inMilliseconds.toDouble());
  }
}
</code></pre>
<h2>Best Practices</h2>
<p>1. <strong>Component Design</strong></p>
<p>- Keep components small and focused</p>
<p>- Use const constructors where possible</p>
<p>- Implement shouldComponentUpdate</p>
<p>
2. <strong>State Management</strong></p>
<p>- Minimize state updates</p>
<p>- Use appropriate state scoping</p>
<p>- Implement efficient selectors</p>
<p>
3. <strong>Resource Loading</strong></p>
<p>- Implement lazy loading</p>
<p>- Optimize asset delivery</p>
<p>- Use appropriate caching strategies</p>
<h2>Tools and Resources</h2>
<p>1. <a href="https://web.dev/vitals/">Web Vitals</a>
2. <a href="https://developers.google.com/web/tools/chrome-devtools/performance">Chrome DevTools Performance Panel</a>
3. <a href="https://developers.google.com/web/tools/lighthouse">Lighthouse</a>
4. <a href="https://www.webpagetest.org/">WebPageTest</a></p>""";
  
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
  String get canonicalUrl => '/blog/performance_optimization';
  
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
  registerPostFactory(() => const BlogPostPerformanceOptimization());
}
