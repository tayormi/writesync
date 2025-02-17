import 'dart:html';
import 'package:writesync/plugins/plugin_interface.dart';
import 'package:nanoid2/nanoid2.dart';
import 'dart:convert';

class LukehogAnalyticsPlugin extends AnalyticsPlugin {
  String? _projectId;
  String? _userId;
  String? _sessionId;
  DateTime? _lastSent;
  bool _isInitialized = false;
  Map<String, dynamic> _config = {};

  @override
  String get name => 'lukehog_analytics';

  @override
  String get version => '1.0.0';

  @override
  String get description => 'Lukehog analytics integration for WriteSync';

  @override
  Future<void> initialize(PluginContext context) async {
    if (_isInitialized) return;

    _config = context.config;
    _projectId = _config['projectId'] as String?;

    if (_projectId == null || _projectId!.isEmpty) {
      throw PluginException('Lukehog Analytics: Missing projectId');
    }

    _isInitialized = true;
    _initializeSession();

    // Configure automatic tracking
    if (_config['automaticPageviews'] == true) {
      _setupAutomaticPageviews();
    }
    if (_config['automaticErrorTracking'] == true) {
      _setupErrorTracking();
    }
  }

  void _initializeSession() {
    // Try to get stored values from localStorage
    _userId = window.localStorage['lukehog-user-id'];
    _sessionId = window.localStorage['lukehog-session-id'];
    final lastSentStr = window.localStorage['lukehog-last-sent'];

    // Initialize user ID if not exists
    if (_userId == null) {
      _userId = 'anon:${nanoid()}';
      window.localStorage['lukehog-user-id'] = _userId!;
    }

    // Initialize or refresh session if needed
    final lastSent =
        lastSentStr != null ? DateTime.tryParse(lastSentStr) : null;
    final sessionExpiration =
        Duration(seconds: _config['sessionExpiration'] as int? ?? 1800);
    if (_sessionId == null ||
        lastSent == null ||
        DateTime.now().difference(lastSent) > sessionExpiration) {
      _sessionId = nanoid();
      window.localStorage['lukehog-session-id'] = _sessionId!;
    }

    _lastSent = DateTime.now();
    window.localStorage['lukehog-last-sent'] = _lastSent!.toIso8601String();
  }

  void _setupAutomaticPageviews() {
    window.onPopState.listen((_) => _trackCurrentPage());
    _trackCurrentPage();
  }

  void _setupErrorTracking() {
    window.onError.listen((event) {
      trackError(
        event.toString(),
        type: 'WindowError',
        properties: {'url': window.location.href},
      );
    });
  }

  void _trackCurrentPage() {
    trackPageView(
      window.location.pathname ?? '',
      properties: {
        'title': document.title,
        'url': window.location.href,
      },
    );
  }

  Future<void> _sendEvent(String event, Map<String, dynamic> properties) async {
    if (!_isInitialized || _projectId == null) return;

    try {
      // Update session if needed
      final sessionExpiration =
          Duration(seconds: _config['sessionExpiration'] as int? ?? 1800);
      if (_lastSent != null &&
          DateTime.now().difference(_lastSent!) > sessionExpiration) {
        _sessionId = nanoid();
        window.localStorage['lukehog-session-id'] = _sessionId!;
      }
      _lastSent = DateTime.now();
      window.localStorage['lukehog-last-sent'] = _lastSent!.toIso8601String();

      // Get event configuration
      final eventConfig = (_config['events'] as Map<String, dynamic>?)?[event]
          as Map<String, dynamic>?;
      if (eventConfig?['enabled'] == false) return;

      // Filter properties based on configuration
      final allowedProperties =
          eventConfig?['properties'] as List<String>? ?? [];
      final filteredProperties = allowedProperties.isEmpty
          ? properties
          : Map.fromEntries(
              properties.entries
                  .where((e) => allowedProperties.contains(e.key)),
            );

      // Prepare event data
      final payload = {
        'event': event,
        'userId': _userId,
        'sessionId': _sessionId,
        'properties': filteredProperties,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
        'debug': _config['debug'] ?? false,
      };

      // Get retry configuration
      final retryConfig = _config['retry'] as Map<String, dynamic>? ?? {};
      final maxAttempts = retryConfig['maxAttempts'] as int? ?? 3;
      final initialDelay = retryConfig['initialDelay'] as int? ?? 100;
      final maxDelay = retryConfig['maxDelay'] as int? ?? 5000;

      final baseUrl = 'https://api.lukehog.com';
      final uri = Uri.parse('$baseUrl/event/$_projectId');

      // Send with retries
      int attempts = 0;
      while (attempts < maxAttempts) {
        try {
          final request = await HttpRequest.request(
            uri.toString(),
            method: 'POST',
            sendData: jsonEncode(payload),
          );

          if (request.status! >= 200 && request.status! < 300) {
            if (_config['debug'] == true) {
              print('Lukehog Analytics: Event sent successfully - $event');
            }
            return;
          }
          throw Exception('HTTP ${request.status}: ${request.statusText}');
        } catch (e) {
          attempts++;
          if (attempts == maxAttempts) {
            if (_config['debug'] == true) {
              print(
                  'Lukehog Analytics: Failed to send event after $maxAttempts attempts - $e');
            }
            rethrow;
          }
          // Wait before retrying, with exponential backoff
          final delay = initialDelay * (1 << attempts);
          await Future.delayed(
              Duration(milliseconds: delay > maxDelay ? maxDelay : delay));
        }
      }
    } catch (e) {
      if (_config['debug'] == true) {
        print('Lukehog Analytics: Error sending event - $e');
      }
    }
  }

  @override
  void trackEvent(String name, {Map<String, dynamic>? properties}) {
    if (!_isInitialized) return;
    _sendEvent(name, properties ?? {});
  }

  @override
  void trackPageView(String path, {Map<String, dynamic>? properties}) {
    if (!_isInitialized) return;
    _sendEvent('page_view', {
      'path': path,
      'title': document.title,
      ...?properties,
    });
  }

  @override
  void trackError(String error,
      {String? type,
      StackTrace? stackTrace,
      Map<String, dynamic>? properties}) {
    if (!_isInitialized) return;
    _sendEvent('error', {
      'error': error,
      if (type != null) 'type': type,
      if (stackTrace != null) 'stackTrace': stackTrace.toString(),
      ...?properties,
    });
  }

  @override
  void setUserId(String? userId) {
    _userId = userId ?? 'anon:${nanoid()}';
    window.localStorage['lukehog-user-id'] = _userId!;
  }

  @override
  Future<void> dispose() async {
    _isInitialized = false;
    _projectId = null;
    _userId = null;
    _sessionId = null;
    _lastSent = null;
    _config = {};
  }
}
