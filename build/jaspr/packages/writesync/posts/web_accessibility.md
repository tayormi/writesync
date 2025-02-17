---
title: Building Accessible Web Apps with Jaspr
date: 2024-03-18
author: Alex Thompson
description: Learn how to create inclusive web applications using Jaspr, ensuring your apps are accessible to all users regardless of their abilities.
tags: [accessibility, web, jaspr, a11y]
image: https://images.unsplash.com/photo-1508921912186-1d1a45ebb3c1
authorImage: https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d
---

# Building Accessible Web Apps with Jaspr

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
4. [A11y Project](https://www.a11yproject.com/) 