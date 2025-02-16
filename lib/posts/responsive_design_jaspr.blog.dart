// Generated code - do not modify by hand
// ignore_for_file: undefined_identifier, expected_identifier, invalid_reference_to_this, non_constant_identifier_names, constant_identifier_names, invalid_element_content

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_blog/models/blog_post.dart';
import 'package:jaspr_blog/posts/blog_post_registry.dart';

class BlogPostResponsiveDesignJaspr extends Component implements BlogPost {
  const BlogPostResponsiveDesignJaspr();
  
  @override
  Element createElement() => createElement();
  
  @override
  String get title => 'Building Responsive Web Apps with Jaspr';
  
  @override
  String get slug => 'responsive-design-jaspr';
  
  @override
  DateTime get publishedAt => DateTime.parse('2024-02-25');
  
  @override
  List<String> get tags => ['dart', 'jaspr', 'responsive', 'design', 'css'];
  
  @override
  String get description => 'Learn how to create beautiful, responsive web applications using Jaspr and modern CSS techniques. Discover best practices for building layouts that work seamlessly across all devices.';
  
  @override
  String get author => 'Sarah Johnson';
  
  @override
  String? get imageUrl => 'https://images.unsplash.com/photo-1508921912186-1d1a45ebb3c1';
  
  @override
  String? get authorImageUrl => null;
  
  @override
  Map<String, String> get metadata => {
    'author_image': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80'
  };
  
  static final String _rawMarkdown = r"""# Building Responsive Web Apps with Jaspr

Creating responsive web applications that work seamlessly across all devices is crucial in today's multi-device world. In this post, we'll explore how to build responsive layouts using Jaspr and modern CSS techniques.

## Understanding Responsive Design

Responsive design is about creating web applications that adapt to different screen sizes and devices. Key concepts include:

1. **Fluid Grids**: Using relative units instead of fixed pixels
2. **Flexible Images**: Images that scale within their containers
3. **Media Queries**: CSS rules that apply based on device characteristics
4. **Mobile-First Approach**: Designing for mobile devices first

## Using Tailwind CSS with Jaspr

Jaspr works great with Tailwind CSS. Here's how to implement responsive designs:

```dart
div(
  classes: '''
    w-full           // Full width on all screens
    md:w-1/2        // Half width on medium screens
    lg:w-1/3        // One-third width on large screens
    p-4             // Padding on all screens
    md:p-6          // Larger padding on medium screens
    lg:p-8          // Even larger padding on large screens
  ''',
  [
    // Your content here
  ],
)
```

## Responsive Layout Patterns

### Stack to Grid

```dart
div(
  classes: '''
    grid
    grid-cols-1     // Single column on mobile
    md:grid-cols-2  // Two columns on medium screens
    lg:grid-cols-3  // Three columns on large screens
    gap-4
  ''',
  [
    for (final item in items)
      ResponsiveCard(item: item),
  ],
)
```

### Sidebar Layout

```dart
div(
  classes: '''
    flex
    flex-col        // Stack on mobile
    lg:flex-row     // Side by side on large screens
    gap-4
  ''',
  [
    // Sidebar
    div(
      classes: '''
        w-full
        lg:w-64
        lg:flex-shrink-0
      ''',
      [/* Sidebar content */],
    ),
    // Main content
    div(
      classes: 'flex-grow',
      [/* Main content */],
    ),
  ],
)
```

## Responsive Images

Handle images responsively:

```dart
div(
  classes: 'relative aspect-[16/9]',
  [
    img(
      src: imageUrl,
      classes: '''
        absolute
        inset-0
        w-full
        h-full
        object-cover
        rounded-lg
      ''',
    ),
  ],
)
```

## Responsive Typography

Implement responsive text sizes:

```dart
h1(
  classes: '''
    text-2xl        // Base size
    sm:text-3xl     // Larger on small screens
    md:text-4xl     // Even larger on medium screens
    lg:text-5xl     // Largest on large screens
    font-bold
    tracking-tight
  ''',
  [text('Responsive Heading')],
)
```

## Navigation Patterns

### Responsive Navigation Bar

```dart
nav(
  classes: '''
    flex
    flex-col        // Stack on mobile
    sm:flex-row     // Row on larger screens
    items-center
    justify-between
    p-4
  ''',
  [
    // Logo
    img(classes: 'h-8 w-auto'),
    
    // Navigation links
    div(
      classes: '''
        flex
        flex-col        // Stack on mobile
        sm:flex-row     // Row on larger screens
        gap-4
        mt-4           // Spacing on mobile
        sm:mt-0        // Remove spacing on larger screens
      ''',
      [
        // Navigation links
      ],
    ),
  ],
)
```

## Best Practices

1. **Mobile-First Development**
   - Start with mobile layouts
   - Add complexity for larger screens
   - Use min-width media queries

2. **Performance**
   - Optimize images for different screen sizes
   - Lazy load off-screen content
   - Minimize layout shifts

3. **Testing**
   - Test on real devices
   - Use browser dev tools
   - Check common breakpoints

4. **Accessibility**
   - Ensure touch targets are large enough
   - Maintain readable text sizes
   - Provide sufficient contrast

## Common Breakpoints

```dart
// Tailwind CSS default breakpoints
final breakpoints = {
  'sm': '640px',   // Small screens
  'md': '768px',   // Medium screens
  'lg': '1024px',  // Large screens
  'xl': '1280px',  // Extra large screens
  '2xl': '1536px', // 2X large screens
};
```

## Handling Dynamic Content

Create flexible layouts that handle varying content:

```dart
div(
  classes: '''
    grid
    grid-cols-1
    sm:grid-cols-2
    lg:grid-cols-3
    auto-rows-fr    // Equal height rows
    gap-4
  ''',
  [
    for (final card in cards)
      div(
        classes: '''
          bg-white
          rounded-lg
          shadow
          p-4
          flex
          flex-col
        ''',
        [
          // Card header
          div(classes: 'flex-shrink-0', [/* Header content */]),
          // Card body
          div(classes: 'flex-grow', [/* Body content */]),
          // Card footer
          div(classes: 'flex-shrink-0', [/* Footer content */]),
        ],
      ),
  ],
)
```

## Conclusion

Building responsive web applications with Jaspr is straightforward when following these patterns and best practices. Remember to:

- Start with mobile layouts
- Use flexible and fluid layouts
- Test across different devices
- Optimize performance
- Maintain accessibility

By following these guidelines, you can create web applications that provide an excellent user experience across all devices.

Stay tuned for more advanced topics on building responsive web applications with Jaspr!""";
  
  @override
  String get markdownContent => _rawMarkdown;
  
  @override
  String get content => r"""<h1>Building Responsive Web Apps with Jaspr</h1>
<p>
Creating responsive web applications that work seamlessly across all devices is crucial in today\'s multi-device world. In this post, we\'ll explore how to build responsive layouts using Jaspr and modern CSS techniques.</p>
<h2>Understanding Responsive Design</h2>
<p>
Responsive design is about creating web applications that adapt to different screen sizes and devices. Key concepts include:</p>
<p>1. <strong>Fluid Grids</strong>: Using relative units instead of fixed pixels
2. <strong>Flexible Images</strong>: Images that scale within their containers
3. <strong>Media Queries</strong>: CSS rules that apply based on device characteristics
4. <strong>Mobile-First Approach</strong>: Designing for mobile devices first</p>
<h2>Using Tailwind CSS with Jaspr</h2>
<p>
Jaspr works great with Tailwind CSS. Here\'s how to implement responsive designs:</p>
<pre><code class="language-dart">div(
  classes: \'\'\'
    w-full           // Full width on all screens
    md:w-1/2        // Half width on medium screens
    lg:w-1/3        // One-third width on large screens
    p-4             // Padding on all screens
    md:p-6          // Larger padding on medium screens
    lg:p-8          // Even larger padding on large screens
  \'\'\',
  [
    // Your content here
  ],
)
</code></pre>
<h2>Responsive Layout Patterns</h2>
<h3>Stack to Grid</h3>
<pre><code class="language-dart">div(
  classes: \'\'\'
    grid
    grid-cols-1     // Single column on mobile
    md:grid-cols-2  // Two columns on medium screens
    lg:grid-cols-3  // Three columns on large screens
    gap-4
  \'\'\',
  [
    for (final item in items)
      ResponsiveCard(item: item),
  ],
)
</code></pre>
<h3>Sidebar Layout</h3>
<pre><code class="language-dart">div(
  classes: \'\'\'
    flex
    flex-col        // Stack on mobile
    lg:flex-row     // Side by side on large screens
    gap-4
  \'\'\',
  [
    // Sidebar
    div(
      classes: \'\'\'
        w-full
        lg:w-64
        lg:flex-shrink-0
      \'\'\',
      [/* Sidebar content */],
    ),
    // Main content
    div(
      classes: \'flex-grow\',
      [/* Main content */],
    ),
  ],
)
</code></pre>
<h2>Responsive Images</h2>
<p>
Handle images responsively:</p>
<pre><code class="language-dart">div(
  classes: \'relative aspect-[16/9]\',
  [
    img(
      src: imageUrl,
      classes: \'\'\'
        absolute
        inset-0
        w-full
        h-full
        object-cover
        rounded-lg
      \'\'\',
    ),
  ],
)
</code></pre>
<h2>Responsive Typography</h2>
<p>
Implement responsive text sizes:</p>
<pre><code class="language-dart">h1(
  classes: \'\'\'
    text-2xl        // Base size
    sm:text-3xl     // Larger on small screens
    md:text-4xl     // Even larger on medium screens
    lg:text-5xl     // Largest on large screens
    font-bold
    tracking-tight
  \'\'\',
  [text(\'Responsive Heading\')],
)
</code></pre>
<h2>Navigation Patterns</h2>
<h3>Responsive Navigation Bar</h3>
<pre><code class="language-dart">nav(
  classes: \'\'\'
    flex
    flex-col        // Stack on mobile
    sm:flex-row     // Row on larger screens
    items-center
    justify-between
    p-4
  \'\'\',
  [
    // Logo
    img(classes: \'h-8 w-auto\'),
    
    // Navigation links
    div(
      classes: \'\'\'
        flex
        flex-col        // Stack on mobile
        sm:flex-row     // Row on larger screens
        gap-4
        mt-4           // Spacing on mobile
        sm:mt-0        // Remove spacing on larger screens
      \'\'\',
      [
        // Navigation links
      ],
    ),
  ],
)
</code></pre>
<h2>Best Practices</h2>
<p>1. <strong>Mobile-First Development</strong></p>
<p>- Start with mobile layouts</p>
<p>- Add complexity for larger screens</p>
<p>- Use min-width media queries</p>
<p>
2. <strong>Performance</strong></p>
<p>- Optimize images for different screen sizes</p>
<p>- Lazy load off-screen content</p>
<p>- Minimize layout shifts</p>
<p>
3. <strong>Testing</strong></p>
<p>- Test on real devices</p>
<p>- Use browser dev tools</p>
<p>- Check common breakpoints</p>
<p>
4. <strong>Accessibility</strong></p>
<p>- Ensure touch targets are large enough</p>
<p>- Maintain readable text sizes</p>
<p>- Provide sufficient contrast</p>
<h2>Common Breakpoints</h2>
<pre><code class="language-dart">// Tailwind CSS default breakpoints
final breakpoints = {
  \'sm\': \'640px\',   // Small screens
  \'md\': \'768px\',   // Medium screens
  \'lg\': \'1024px\',  // Large screens
  \'xl\': \'1280px\',  // Extra large screens
  \'2xl\': \'1536px\', // 2X large screens
};
</code></pre>
<h2>Handling Dynamic Content</h2>
<p>
Create flexible layouts that handle varying content:</p>
<pre><code class="language-dart">div(
  classes: \'\'\'
    grid
    grid-cols-1
    sm:grid-cols-2
    lg:grid-cols-3
    auto-rows-fr    // Equal height rows
    gap-4
  \'\'\',
  [
    for (final card in cards)
      div(
        classes: \'\'\'
          bg-white
          rounded-lg
          shadow
          p-4
          flex
          flex-col
        \'\'\',
        [
          // Card header
          div(classes: \'flex-shrink-0\', [/* Header content */]),
          // Card body
          div(classes: \'flex-grow\', [/* Body content */]),
          // Card footer
          div(classes: \'flex-shrink-0\', [/* Footer content */]),
        ],
      ),
  ],
)
</code></pre>
<h2>Conclusion</h2>
<p>
Building responsive web applications with Jaspr is straightforward when following these patterns and best practices. Remember to:</p>
<p>- Start with mobile layouts</p>
<p>- Use flexible and fluid layouts</p>
<p>- Test across different devices</p>
<p>- Optimize performance</p>
<p>- Maintain accessibility</p>
<p>
By following these guidelines, you can create web applications that provide an excellent user experience across all devices.</p>
<p>
Stay tuned for more advanced topics on building responsive web applications with Jaspr!</p>""";
  
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
  String get canonicalUrl => '/blog/responsive-design-jaspr';
  
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
  registerPostFactory(() => const BlogPostResponsiveDesignJaspr());
}
