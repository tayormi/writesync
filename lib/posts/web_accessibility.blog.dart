// Generated code - do not modify by hand
// ignore_for_file: undefined_identifier, expected_identifier, invalid_reference_to_this, non_constant_identifier_names, constant_identifier_names, invalid_element_content

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_blog/models/blog_post.dart';
import 'package:jaspr_blog/posts/blog_post_registry.dart';

class BlogPostWebAccessibility extends Component implements BlogPost {
  const BlogPostWebAccessibility();
  
  @override
  Element createElement() => createElement();
  
  @override
  String get title => 'Building Accessible Web Apps with Jaspr';
  
  @override
  String get slug => 'web_accessibility';
  
  @override
  DateTime get publishedAt => DateTime.parse('2024-03-18');
  
  @override
  List<String> get tags => ['accessibility', 'web', 'jaspr', 'a11y'];
  
  @override
  String get description => 'Learn how to create inclusive web applications using Jaspr, ensuring your apps are accessible to all users regardless of their abilities.';
  
  @override
  String get author => 'Alex Thompson';
  
  @override
  String? get imageUrl => 'https://images.unsplash.com/photo-1629196914168-3a2652305f8f';
  
  @override
  String? get authorImageUrl => 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d';
  
  @override
  Map<String, String> get metadata => {
    
  };
  
  static final String _rawMarkdown = r"""# Building Accessible Web Apps with Jaspr

Web accessibility is not just a nice-to-have feature—it's a necessity. In this guide, we'll explore how to make your Jaspr applications accessible to all users, including those who rely on assistive technologies.

## Understanding Web Accessibility

Accessibility (often abbreviated as a11y) ensures that your web applications are usable by everyone, including people with:

- Visual impairments
- Hearing impairments
- Motor impairments
- Cognitive impairments

## ARIA Attributes in Jaspr

Here's how to implement ARIA attributes in your Jaspr components:

```dart
div(
  attributes: {
    'role': 'alert',
    'aria-live': 'polite',
    'aria-atomic': 'true',
  },
  [
    text('Important notification'),
  ],
)
```

## Semantic HTML

Using semantic HTML is crucial for accessibility. Here's how to structure your content:

```dart
article(
  classes: 'blog-post',
  [
    header([
      h1([text('Main Title')]),
      p(classes: 'meta', [text('Posted on March 18, 2024')]),
    ]),
    main([
      section([
        h2([text('Introduction')]),
        p([text('Content goes here...')]),
      ]),
    ]),
    footer([
      nav(
        attributes: {'aria-label': 'Post navigation'},
        [
          // Navigation links
        ],
      ),
    ]),
  ],
)
```

## Keyboard Navigation

Ensure your application is fully navigable using only a keyboard:

```dart
button(
  classes: 'focus:ring-2 focus:ring-blue-500 focus:outline-none',
  attributes: {
    'tabindex': '0',
    'role': 'button',
    'aria-pressed': 'false',
  },
  events: {
    'keydown': (event) {
      if (event.keyCode == KeyCode.enter || 
          event.keyCode == KeyCode.space) {
        // Handle activation
      }
    },
  },
  [text('Click me')],
)
```

## Color Contrast

Ensure sufficient color contrast for text and interactive elements:

```dart
// Good contrast
div(
  classes: '''
    text-gray-900 dark:text-white
    bg-white dark:bg-gray-800
  ''',
  [
    text('High contrast text'),
  ],
)

// Bad contrast - avoid
div(
  classes: 'text-gray-400 bg-gray-200',
  [
    text('Low contrast text'),
  ],
)
```

## Focus Management

Implement proper focus management for dynamic content:

```dart
class AccessibleDialog extends StatefulComponent {
  @override
  State<AccessibleDialog> createState() => _AccessibleDialogState();
}

class _AccessibleDialogState extends State<AccessibleDialog> {
  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div(
      attributes: {
        'role': 'dialog',
        'aria-modal': 'true',
        'aria-labelledby': 'dialog-title',
      },
      [
        h2(
          id: 'dialog-title',
          [text('Dialog Title')],
        ),
        // Dialog content
        div(
          attributes: {'tabindex': '-1'},
          events: {
            'focus': (event) {
              // Trap focus within dialog
            },
          },
          [],
        ),
      ],
    );
  }
}
```

## Screen Reader Announcements

Implement screen reader announcements for dynamic updates:

```dart
class LiveRegion extends StatefulComponent {
  final String message;
  
  LiveRegion({required this.message});
  
  @override
  State<LiveRegion> createState() => _LiveRegionState();
}

class _LiveRegionState extends State<LiveRegion> {
  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div(
      attributes: {
        'aria-live': 'polite',
        'aria-atomic': 'true',
        'class': 'sr-only', // Visually hidden
      },
      [text(component.message)],
    );
  }
}
```

## Form Accessibility

Make your forms accessible with proper labels and error handling:

```dart
form(
  attributes: {'novalidate': 'true'},
  [
    div(classes: 'form-group', [
      label(
        attributes: {'for': 'email'},
        [text('Email address')],
      ),
      input(
        [],
        attributes: {
          'id': 'email',
          'type': 'email',
          'aria-required': 'true',
          'aria-invalid': 'false',
          'aria-describedby': 'email-error',
        },
      ),
      div(
        id: 'email-error',
        classes: 'error-message',
        attributes: {'role': 'alert'},
        [],
      ),
    ]),
  ],
)
```

## Testing Accessibility

Here are some ways to test your application's accessibility:

1. **Automated Testing**
```dart
test('Component meets accessibility standards', () {
  // Implement accessibility checks
  expect(component.getAttribute('role'), isNotNull);
  expect(component.getAttribute('aria-label'), isNotNull);
});
```

2. **Manual Testing**
- Use keyboard navigation
- Test with screen readers
- Verify color contrast
- Check focus management

## Best Practices

1. **Structure**
   - Use semantic HTML
   - Implement proper heading hierarchy
   - Provide skip links

2. **Interactive Elements**
   - Ensure keyboard accessibility
   - Maintain visible focus indicators
   - Use proper ARIA roles

3. **Content**
   - Write clear, concise text
   - Provide text alternatives for images
   - Use sufficient color contrast

## Resources

1. [Web Content Accessibility Guidelines (WCAG)](https://www.w3.org/WAI/standards-guidelines/wcag/)
2. [WAI-ARIA Practices](https://www.w3.org/WAI/ARIA/apg/)
3. [Jaspr Accessibility Documentation](https://docs.page/schultek/jaspr)
4. [A11y Project](https://www.a11yproject.com/)""";
  
  @override
  String get markdownContent => _rawMarkdown;
  
  @override
  String get content => r"""<h1>Building Accessible Web Apps with Jaspr</h1>
<p>
Web accessibility is not just a nice-to-have feature—it\'s a necessity. In this guide, we\'ll explore how to make your Jaspr applications accessible to all users, including those who rely on assistive technologies.</p>
<h2>Understanding Web Accessibility</h2>
<p>
Accessibility (often abbreviated as a11y) ensures that your web applications are usable by everyone, including people with:</p>
<p>- Visual impairments</p>
<p>- Hearing impairments</p>
<p>- Motor impairments</p>
<p>- Cognitive impairments</p>
<h2>ARIA Attributes in Jaspr</h2>
<p>
Here\'s how to implement ARIA attributes in your Jaspr components:</p>
<pre><code class="language-dart">div(
  attributes: {
    \'role\': \'alert\',
    \'aria-live\': \'polite\',
    \'aria-atomic\': \'true\',
  },
  [
    text(\'Important notification\'),
  ],
)
</code></pre>
<h2>Semantic HTML</h2>
<p>
Using semantic HTML is crucial for accessibility. Here\'s how to structure your content:</p>
<pre><code class="language-dart">article(
  classes: \'blog-post\',
  [
    header([
      h1([text(\'Main Title\')]),
      p(classes: \'meta\', [text(\'Posted on March 18, 2024\')]),
    ]),
    main([
      section([
        h2([text(\'Introduction\')]),
        p([text(\'Content goes here...\')]),
      ]),
    ]),
    footer([
      nav(
        attributes: {\'aria-label\': \'Post navigation\'},
        [
          // Navigation links
        ],
      ),
    ]),
  ],
)
</code></pre>
<h2>Keyboard Navigation</h2>
<p>
Ensure your application is fully navigable using only a keyboard:</p>
<pre><code class="language-dart">button(
  classes: \'focus:ring-2 focus:ring-blue-500 focus:outline-none\',
  attributes: {
    \'tabindex\': \'0\',
    \'role\': \'button\',
    \'aria-pressed\': \'false\',
  },
  events: {
    \'keydown\': (event) {
      if (event.keyCode == KeyCode.enter || 
          event.keyCode == KeyCode.space) {
        // Handle activation
      }
    },
  },
  [text(\'Click me\')],
)
</code></pre>
<h2>Color Contrast</h2>
<p>
Ensure sufficient color contrast for text and interactive elements:</p>
<pre><code class="language-dart">// Good contrast
div(
  classes: \'\'\'
    text-gray-900 dark:text-white
    bg-white dark:bg-gray-800
  \'\'\',
  [
    text(\'High contrast text\'),
  ],
)

// Bad contrast - avoid
div(
  classes: \'text-gray-400 bg-gray-200\',
  [
    text(\'Low contrast text\'),
  ],
)
</code></pre>
<h2>Focus Management</h2>
<p>
Implement proper focus management for dynamic content:</p>
<pre><code class="language-dart">class AccessibleDialog extends StatefulComponent {
  @override
  State&lt;AccessibleDialog&gt; createState() =&gt; _AccessibleDialogState();
}

class _AccessibleDialogState extends State&lt;AccessibleDialog&gt; {
  @override
  Iterable&lt;Component&gt; build(BuildContext context) sync* {
    yield div(
      attributes: {
        \'role\': \'dialog\',
        \'aria-modal\': \'true\',
        \'aria-labelledby\': \'dialog-title\',
      },
      [
        h2(
          id: \'dialog-title\',
          [text(\'Dialog Title\')],
        ),
        // Dialog content
        div(
          attributes: {\'tabindex\': \'-1\'},
          events: {
            \'focus\': (event) {
              // Trap focus within dialog
            },
          },
          [],
        ),
      ],
    );
  }
}
</code></pre>
<h2>Screen Reader Announcements</h2>
<p>
Implement screen reader announcements for dynamic updates:</p>
<pre><code class="language-dart">class LiveRegion extends StatefulComponent {
  final String message;
  
  LiveRegion({required this.message});
  
  @override
  State&lt;LiveRegion&gt; createState() =&gt; _LiveRegionState();
}

class _LiveRegionState extends State&lt;LiveRegion&gt; {
  @override
  Iterable&lt;Component&gt; build(BuildContext context) sync* {
    yield div(
      attributes: {
        \'aria-live\': \'polite\',
        \'aria-atomic\': \'true\',
        \'class\': \'sr-only\', // Visually hidden
      },
      [text(component.message)],
    );
  }
}
</code></pre>
<h2>Form Accessibility</h2>
<p>
Make your forms accessible with proper labels and error handling:</p>
<pre><code class="language-dart">form(
  attributes: {\'novalidate\': \'true\'},
  [
    div(classes: \'form-group\', [
      label(
        attributes: {\'for\': \'email\'},
        [text(\'Email address\')],
      ),
      input(
        [],
        attributes: {
          \'id\': \'email\',
          \'type\': \'email\',
          \'aria-required\': \'true\',
          \'aria-invalid\': \'false\',
          \'aria-describedby\': \'email-error\',
        },
      ),
      div(
        id: \'email-error\',
        classes: \'error-message\',
        attributes: {\'role\': \'alert\'},
        [],
      ),
    ]),
  ],
)
</code></pre>
<h2>Testing Accessibility</h2>
<p>
Here are some ways to test your application\'s accessibility:</p>
<p>1. <strong>Automated Testing</strong></p>
<pre><code class="language-dart">test(\'Component meets accessibility standards\', () {
  // Implement accessibility checks
  expect(component.getAttribute(\'role\'), isNotNull);
  expect(component.getAttribute(\'aria-label\'), isNotNull);
});
</code></pre>
<p>
2. <strong>Manual Testing</strong></p>
<p>- Use keyboard navigation</p>
<p>- Test with screen readers</p>
<p>- Verify color contrast</p>
<p>- Check focus management</p>
<h2>Best Practices</h2>
<p>1. <strong>Structure</strong></p>
<p>- Use semantic HTML</p>
<p>- Implement proper heading hierarchy</p>
<p>- Provide skip links</p>
<p>
2. <strong>Interactive Elements</strong></p>
<p>- Ensure keyboard accessibility</p>
<p>- Maintain visible focus indicators</p>
<p>- Use proper ARIA roles</p>
<p>
3. <strong>Content</strong></p>
<p>- Write clear, concise text</p>
<p>- Provide text alternatives for images</p>
<p>- Use sufficient color contrast</p>
<h2>Resources</h2>
<p>1. <a href="https://www.w3.org/WAI/standards-guidelines/wcag/">Web Content Accessibility Guidelines (WCAG)</a>
2. <a href="https://www.w3.org/WAI/ARIA/apg/">WAI-ARIA Practices</a>
3. <a href="https://docs.page/schultek/jaspr">Jaspr Accessibility Documentation</a>
4. <a href="https://www.a11yproject.com/">A11y Project</a></p>""";
  
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
  String get canonicalUrl => '/blog/web_accessibility';
  
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
  registerPostFactory(() => const BlogPostWebAccessibility());
}
