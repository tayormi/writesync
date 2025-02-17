import 'dart:async';
import 'dart:convert';
import 'dart:html' show window, document, HttpRequest;
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../config/site_config.dart';

final customAnalyticsProvider =
    Provider<CustomAnalytics>((ref) => CustomAnalytics());

class AnalyticsEvent {
  final String name;
  final String category;
  final Map<String, dynamic> properties;
  final DateTime timestamp;

  AnalyticsEvent({
    required this.name,
    required this.category,
    required this.properties,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'name': name,
        'category': category,
        'properties': properties,
        'timestamp': timestamp.toIso8601String(),
      };
}

class CustomAnalytics {
  final _eventQueue = <AnalyticsEvent>[];
  Timer? _batchTimer;
  bool _isSending = false;
  final _config = SiteConfig.analytics['customAnalytics'];

  CustomAnalytics() {
    if (_isEnabled) {
      _startBatchProcessing();
    }
  }

  bool get _isEnabled =>
      SiteConfig.analytics['enabled'] && _config['enabled'] == true;

  void trackEvent(AnalyticsEvent event) {
    if (!_isEnabled) return;

    _eventQueue.add(event);
    _maybeProcessQueue();
  }

  void _startBatchProcessing() {
    final interval = _config['options']['batchIntervalMs'] as int;
    _batchTimer?.cancel();
    _batchTimer = Timer.periodic(
      Duration(milliseconds: interval),
      (_) => _maybeProcessQueue(),
    );
  }

  void _maybeProcessQueue() {
    if (!_isSending && _eventQueue.isNotEmpty) {
      _processBatch();
    }
  }

  Future<void> _processBatch() async {
    if (_isSending || _eventQueue.isEmpty) return;

    _isSending = true;
    final batchSize = _config['options']['batchSize'] as int;
    final events = _eventQueue.take(batchSize).toList();
    final remainingAttempts = _config['options']['retryAttempts'] as int;

    try {
      await _sendEvents(events, remainingAttempts);
      _eventQueue.removeRange(0, events.length);
    } catch (e) {
      if (_config['options']['debugMode']) {
        print('Analytics error: $e');
      }
    } finally {
      _isSending = false;
      _maybeProcessQueue();
    }
  }

  Future<void> _sendEvents(List<AnalyticsEvent> events, int attempts) async {
    if (attempts <= 0) {
      _eventQueue.removeRange(0, events.length);
      return;
    }

    try {
      final payload = jsonEncode({
        'events': events.map((e) => e.toJson()).toList(),
        'metadata': {
          'url': window.location.href,
          'userAgent': window.navigator.userAgent,
          'timestamp': DateTime.now().toIso8601String(),
        },
      });

      final request = await HttpRequest.request(
        _config['endpoint'],
        method: 'POST',
        requestHeaders: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_config['apiKey']}',
        },
        sendData: payload,
      );

      if (!_isSuccessResponse(request.status)) {
        throw Exception(
            'Failed to send events: ${request.status} ${request.statusText}');
      }
    } catch (e) {
      if (attempts > 1) {
        await Future.delayed(Duration(seconds: 1));
        await _sendEvents(events, attempts - 1);
      } else {
        rethrow;
      }
    }
  }

  bool _isSuccessResponse(int? statusCode) {
    return statusCode != null && statusCode >= 200 && statusCode < 300;
  }

  void dispose() {
    _batchTimer?.cancel();
    _eventQueue.clear();
  }

  // Convenience methods for common events
  void trackPageView(String path, {Map<String, dynamic>? properties}) {
    if (!_isEnabled || !_config['customEvents']['trackPageViews']) return;

    trackEvent(AnalyticsEvent(
      name: 'page_view',
      category: 'Navigation',
      properties: {
        'path': path,
        'title': document.title,
        ...?properties,
      },
    ));
  }

  void trackClick(String element, {Map<String, dynamic>? properties}) {
    if (!_isEnabled || !_config['customEvents']['trackClicks']) return;

    trackEvent(AnalyticsEvent(
      name: 'click',
      category: 'Interaction',
      properties: {
        'element': element,
        ...?properties,
      },
    ));
  }

  void trackError(String error,
      {String? type,
      StackTrace? stackTrace,
      Map<String, dynamic>? properties}) {
    if (!_isEnabled || !_config['customEvents']['trackErrors']) return;

    trackEvent(AnalyticsEvent(
      name: 'error',
      category: 'Error',
      properties: {
        'error': error,
        if (type != null) 'type': type,
        if (stackTrace != null) 'stackTrace': stackTrace.toString(),
        ...?properties,
      },
    ));
  }

  void trackPerformance(String metric, double value,
      {Map<String, dynamic>? properties}) {
    if (!_isEnabled || !_config['customEvents']['trackPerformance']) return;

    trackEvent(AnalyticsEvent(
      name: 'performance',
      category: 'Performance',
      properties: {
        'metric': metric,
        'value': value,
        ...?properties,
      },
    ));
  }
}
