import 'package:writesync/plugins/plugin_schema.dart';

class LukehogAnalyticsSchema extends PluginSchema {
  @override
  String get name => 'lukehog_analytics';

  @override
  String get version => '1.0.0';

  @override
  String get description => 'Lukehog analytics integration for WriteSync';

  @override
  String get author => 'Your Name';

  @override
  String get homepage => 'https://github.com/yourusername/writesync-lukehog';

  @override
  List<String> get dependencies => ['lukehog_client: ^1.0.0'];

  @override
  List<PluginOptionSchema> get options => [
        PluginOptionSchema(
          name: 'projectId',
          type: String,
          required: true,
          description: 'Your Lukehog project ID',
          validators: [
            PatternValidator(
              pattern: RegExp(r'^[A-Za-z0-9_-]+$'),
              message:
                  'Project ID must contain only letters, numbers, underscores, and hyphens',
            ),
          ],
        ),
        PluginOptionSchema(
          name: 'debug',
          type: bool,
          defaultValue: false,
          description: 'Enable debug mode',
        ),
        PluginOptionSchema(
          name: 'automaticPageviews',
          type: bool,
          defaultValue: true,
          description: 'Automatically track page views',
        ),
        PluginOptionSchema(
          name: 'automaticErrorTracking',
          type: bool,
          defaultValue: true,
          description: 'Automatically track JavaScript errors',
        ),
        PluginOptionSchema(
          name: 'sessionExpiration',
          type: int,
          defaultValue: 1800,
          validators: [
            RangeValidator(min: 300, max: 7200),
          ],
          description: 'Session expiration in seconds (5-120 minutes)',
        ),
        PluginOptionSchema(
          name: 'events',
          type: Map,
          defaultValue: {
            'pageView': {
              'enabled': true,
              'properties': ['url', 'title', 'referrer'],
            },
            'error': {
              'enabled': true,
              'properties': ['message', 'type', 'stackTrace', 'url'],
            },
            'interaction': {
              'enabled': true,
              'properties': ['element', 'action', 'category'],
            },
          },
          description: 'Event tracking configuration',
        ),
        PluginOptionSchema(
          name: 'retry',
          type: Map,
          defaultValue: {
            'maxAttempts': 3,
            'initialDelay': 100,
            'maxDelay': 5000,
          },
          description: 'Retry configuration for failed requests',
        ),
        PluginOptionSchema(
          name: 'batch',
          type: Map,
          defaultValue: {
            'enabled': true,
            'maxSize': 10,
            'flushInterval': 2000,
          },
          description: 'Batch processing configuration',
        ),
        PluginOptionSchema(
          name: 'storage',
          type: Map,
          defaultValue: {
            'prefix': 'lukehog:',
            'maxItems': 1000,
            'maxAge': 604800,
          },
          description: 'Local storage configuration',
        ),
      ];
}
