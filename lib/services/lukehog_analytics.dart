import 'dart:html';
import 'dart:convert';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:nanoid2/nanoid2.dart';
import '../config/site_config.dart';

final lukehogAnalyticsProvider = Provider<LukehogAnalytics>((ref) {
  return LukehogAnalytics();
});

class LukehogAnalytics {
  String? _projectId;
  String? _userId;
  String? _sessionId;
  DateTime? _lastSent;
  bool _isInitialized = false;
  static const Duration _sessionExpiration = Duration(minutes: 30);
  static const String _baseUrl = 'https://api.lukehog.com';
  static const int _maxRetries = 3;

  LukehogAnalytics() {
    _initialize();
  }

  void _initialize() {
    if (_isInitialized) return;
    if (!SiteConfig.analytics['enabled'] ||
        !SiteConfig.analytics['lukehog']['enabled']) {
      return;
    }

    final config = SiteConfig.analytics['lukehog'];
    _projectId = config['projectId'] as String;

    if (_projectId?.isEmpty ?? true) {
      print('Lukehog Analytics: Missing projectId');
      return;
    }

    _isInitialized = true;
    _initializeSession();

    // Configure automatic tracking
    final options = config['options'] as Map<String, dynamic>;
    if (options['automaticPageviews'] == true) {
      _setupAutomaticPageviews();
    }
    if (options['automaticErrorTracking'] == true) {
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
    if (_sessionId == null ||
        lastSent == null ||
        DateTime.now().difference(lastSent) > _sessionExpiration) {
      _sessionId = nanoid();
      window.localStorage['lukehog-session-id'] = _sessionId!;
    }

    _lastSent = DateTime.now();
    window.localStorage['lukehog-last-sent'] = _lastSent!.toIso8601String();
  }

  void _setupAutomaticPageviews() {
    // Listen for route changes and track page views
    window.onPopState.listen((_) => _trackCurrentPage());
    _trackCurrentPage();
  }

  void _trackCurrentPage() {
    trackEvent('page_view', properties: {
      'path': window.location.pathname,
      'title': document.title,
      'url': window.location.href,
    });
  }

  void _setupErrorTracking() {
    window.onError.listen((event) {
      trackEvent('error', properties: {
        'message': event.toString(),
        'type': 'WindowError',
        'url': window.location.href,
      });
    });
  }

  Future<void> _sendEvent(String event, Map<String, dynamic> properties) async {
    if (!_isInitialized || _projectId == null) return;

    try {
      // Update session if needed
      if (_lastSent != null &&
          DateTime.now().difference(_lastSent!) > _sessionExpiration) {
        _sessionId = nanoid();
        window.localStorage['lukehog-session-id'] = _sessionId!;
      }
      _lastSent = DateTime.now();
      window.localStorage['lukehog-last-sent'] = _lastSent!.toIso8601String();

      // Prepare event data
      final payload = jsonEncode({
        'event': event,
        'userId': _userId,
        'sessionId': _sessionId,
        'properties': properties,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
        'debug': SiteConfig.analytics['lukehog']['options']['debugMode'],
      });

      // Send with retries
      int attempts = 0;
      while (attempts < _maxRetries) {
        try {
          final request = await HttpRequest.request(
            '$_baseUrl/event/$_projectId',
            method: 'POST',
            sendData: payload,
            // Don't send any headers for Lukehog endpoint
          );

          final status = request.status;
          if (status != null && status >= 200 && status < 300) {
            return; // Success
          }
          throw HttpRequestException(request);
        } catch (e) {
          attempts++;
          if (attempts == _maxRetries) {
            rethrow;
          }
          // Wait before retrying, with exponential backoff
          await Future.delayed(Duration(milliseconds: 100 * (1 << attempts)));
        }
      }
    } catch (e) {
      print('Lukehog Analytics: Failed to send event - $e');
    }
  }

  void trackEvent(
    String name, {
    Map<String, dynamic>? properties,
  }) {
    if (!_isInitialized) return;

    _sendEvent(name, {
      ...?properties,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void setUserId(String userId) {
    _userId = userId;
    window.localStorage['lukehog-user-id'] = userId;
  }

  void clearUserId() {
    setUserId('anon:${nanoid()}');
  }
}

class HttpRequestException implements Exception {
  final HttpRequest request;
  HttpRequestException(this.request);

  @override
  String toString() => 'HTTP ${request.status}: ${request.statusText}';
}
