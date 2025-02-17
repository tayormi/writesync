# WriteSync Lukehog Analytics Plugin

A plugin for WriteSync that integrates Lukehog analytics, providing seamless event tracking, user analytics, and performance monitoring.

[![Pub Version](https://img.shields.io/pub/v/writesync_lukehog.svg)](https://pub.dev/packages/writesync_lukehog)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## Features

- 🔄 Automatic page view tracking
- 🐛 Automatic error tracking
- 👤 User session management
- 📊 Event batching and retry logic
- 🌓 Dark/Light mode support
- 🔒 Secure data handling
- ⚡ Performance optimized
- 🎯 Configurable event filtering

## Installation

1. Add the plugin to your `pubspec.yaml`:
```yaml
dependencies:
  writesync_lukehog: ^1.0.0
```

2. Register the plugin in your WriteSync app:
```dart
import 'package:writesync_lukehog/writesync_lukehog.dart';

void main() {
  // Register the plugin
  registerPlugin();
  
  // Run your app
  runApp(const App());
}
```

3. Configure the plugin in your `config/plugins.yaml`:
```yaml
plugins:
  lukehog_analytics:
    enabled: true
    options:
      projectId: "${LUKEHOG_PROJECT_ID}"
      debug: false
      automaticPageviews: true
      automaticErrorTracking: true
```

## Configuration

### Required Options

- `projectId` (String): Your Lukehog project ID
  - Must contain only letters, numbers, underscores, and hyphens
  - Required for plugin initialization

### Optional Options

#### Debug Mode
```yaml
debug: true  # Enable debug logging (default: false)
```

#### Automatic Tracking
```yaml
automaticPageviews: true      # Track page views automatically (default: true)
automaticErrorTracking: true  # Track JavaScript errors automatically (default: true)
```

#### Session Management
```yaml
sessionExpiration: 1800  # Session timeout in seconds (default: 1800)
```

#### Event Configuration
```yaml
events:
  pageView:
    enabled: true
    properties:
      - url
      - title
      - referrer
  
  error:
    enabled: true
    properties:
      - message
      - type
      - stackTrace
      - url
  
  interaction:
    enabled: true
    properties:
      - element
      - action
      - category
```

#### Retry Configuration
```yaml
retry:
  maxAttempts: 3        # Maximum retry attempts (default: 3)
  initialDelay: 100     # Initial delay in ms (default: 100)
  maxDelay: 5000        # Maximum delay in ms (default: 5000)
```

#### Batch Processing
```yaml
batch:
  enabled: true         # Enable batch processing (default: true)
  maxSize: 10          # Maximum batch size (default: 10)
  flushInterval: 2000   # Flush interval in ms (default: 2000)
```

#### Storage Configuration
```yaml
storage:
  prefix: 'lukehog:'    # Storage key prefix (default: 'lukehog:')
  maxItems: 1000        # Maximum stored items (default: 1000)
  maxAge: 604800        # Maximum age in seconds (default: 604800)
```

## Usage

### Manual Event Tracking

```dart
// Get plugin instance
final analytics = context.read(pluginRegistryProvider)
    .getPlugin<AnalyticsPlugin>('lukehog_analytics');

// Track custom event
analytics.trackEvent(
  'button_click',
  properties: {
    'buttonId': 'submit',
    'category': 'form',
  },
);

// Track page view
analytics.trackPageView(
  '/dashboard',
  properties: {
    'title': 'User Dashboard',
    'referrer': '/home',
  },
);

// Track error
analytics.trackError(
  'Failed to load data',
  type: 'ApiError',
  properties: {
    'endpoint': '/api/data',
    'statusCode': 500,
  },
);

// Set user ID
analytics.setUserId('user123');
```

### Using the Monitoring Mixin

```dart
class MyComponent extends StatefulComponent {
  @override
  State<MyComponent> createState() => _MyComponentState();
}

class _MyComponentState extends State<MyComponent> with MonitoringMixin {
  void _handleClick() {
    trackComponentInteraction(
      'button',
      'click',
      properties: {'action': 'submit'},
    );
  }

  Future<void> _loadData() async {
    await trackOperation(
      'loadData',
      () async {
        // Your async operation here
      },
    );
  }
}
```

## Development

### Running Tests
```bash
dart test
```

### Building Documentation
```bash
dart doc .
```

### Local Development
1. Clone the repository
2. Link the plugin to your WriteSync project:
```yaml
dependencies:
  writesync_lukehog:
    path: ../plugins/writesync_lukehog
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Lukehog Analytics](https://lukehog.com) for their excellent analytics platform
- [WriteSync](https://github.com/yourusername/writesync) team for the plugin system
- All contributors who have helped improve this plugin 