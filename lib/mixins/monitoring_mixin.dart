import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../config/site_config.dart';
import '../services/services.dart';

mixin MonitoringMixin<T extends StatefulComponent> on State<T> {
  PerformanceMonitor? _monitor;
  CustomAnalytics? _customAnalytics;
  LukehogAnalytics? _lukehogAnalytics;
  String get _componentName => T.toString();

  @override
  void initState() {
    super.initState();
    if (SiteConfig.enablePerformanceMonitoring) {
      _monitor = context.read(performanceMonitorProvider);
      _customAnalytics = context.read(customAnalyticsProvider);
      _lukehogAnalytics = context.read(lukehogAnalyticsProvider);
      _trackComponentMount();
    }
  }

  @override
  void dispose() {
    if (SiteConfig.enablePerformanceMonitoring) {
      _trackComponentUnmount();
    }
    super.dispose();
  }

  void trackComponentEvent(String action, {Map<String, dynamic>? properties}) {
    final eventProperties = {
      'component': _componentName,
      'action': action,
      ...?properties,
    };

    // Track with GA4
    _monitor?.trackEvent(
      'component_event',
      category: 'Component',
      label: action,
      properties: eventProperties,
    );

    // Track with custom analytics
    _customAnalytics?.trackEvent(AnalyticsEvent(
      name: 'component_event',
      category: 'Component',
      properties: eventProperties,
    ));

    // Track with Lukehog
    _lukehogAnalytics?.trackEvent(
      'component_event',
      properties: eventProperties,
    );
  }

  void trackComponentError(
    String error, {
    String? type,
    StackTrace? stackTrace,
    Map<String, dynamic>? properties,
  }) {
    final errorProperties = {
      'component': _componentName,
      'message': error,
      if (type != null) 'type': type,
      if (stackTrace != null) 'stackTrace': stackTrace.toString(),
      ...?properties,
    };

    // Track with GA4
    _monitor?.trackError(
      error,
      type: type ?? 'ComponentError',
      stackTrace: stackTrace,
      properties: errorProperties,
    );

    // Track with custom analytics
    _customAnalytics?.trackError(
      error,
      type: type,
      stackTrace: stackTrace,
      properties: errorProperties,
    );

    // Track with Lukehog
    _lukehogAnalytics?.trackEvent(
      'error',
      properties: errorProperties,
    );
  }

  void trackComponentInteraction(
    String element,
    String action, {
    Map<String, dynamic>? properties,
  }) {
    final interactionProperties = {
      'component': _componentName,
      'element': element,
      'action': action,
      ...?properties,
    };

    // Track with GA4
    _monitor?.trackInteraction(
      element,
      action,
      category: _componentName,
      properties: properties,
    );

    // Track with custom analytics
    _customAnalytics?.trackClick(
      element,
      properties: interactionProperties,
    );

    // Track with Lukehog
    _lukehogAnalytics?.trackEvent(
      'interaction',
      properties: interactionProperties,
    );
  }

  void _trackComponentMount() {
    final mountProperties = {
      'component': _componentName,
      'timestamp': DateTime.now().toIso8601String(),
      'action': 'mount',
    };

    // Track with GA4
    _monitor?.trackEvent(
      'component_lifecycle',
      category: 'Component',
      label: 'mount',
      properties: mountProperties,
    );

    // Track with custom analytics
    _customAnalytics?.trackEvent(AnalyticsEvent(
      name: 'component_lifecycle',
      category: 'Component',
      properties: mountProperties,
    ));

    // Track with Lukehog
    _lukehogAnalytics?.trackEvent(
      'component_lifecycle',
      properties: mountProperties,
    );
  }

  void _trackComponentUnmount() {
    final unmountProperties = {
      'component': _componentName,
      'timestamp': DateTime.now().toIso8601String(),
      'action': 'unmount',
    };

    // Track with GA4
    _monitor?.trackEvent(
      'component_lifecycle',
      category: 'Component',
      label: 'unmount',
      properties: unmountProperties,
    );

    // Track with custom analytics
    _customAnalytics?.trackEvent(AnalyticsEvent(
      name: 'component_lifecycle',
      category: 'Component',
      properties: unmountProperties,
    ));

    // Track with Lukehog
    _lukehogAnalytics?.trackEvent(
      'component_lifecycle',
      properties: unmountProperties,
    );
  }

  Future<T> trackOperation<T>(
    String name,
    Future<T> Function() operation,
  ) async {
    final startTime = DateTime.now();
    try {
      final result = await (_monitor?.measureOperation(
            name: '$_componentName.$name',
            operation: operation,
          ) ??
          operation());

      final duration = DateTime.now().difference(startTime);
      final durationMs = duration.inMilliseconds.toDouble();
      final successProperties = {
        'component': _componentName,
        'operation': name,
        'duration_ms': durationMs,
        'success': true,
      };

      // Track with custom analytics
      _customAnalytics?.trackPerformance(
        '$_componentName.$name',
        durationMs,
        properties: successProperties,
      );

      // Track with Lukehog
      _lukehogAnalytics?.trackEvent(
        'operation',
        properties: successProperties,
      );

      return result;
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime);
      final durationMs = duration.inMilliseconds.toDouble();
      final errorProperties = {
        'component': _componentName,
        'operation': name,
        'duration_ms': durationMs,
        'success': false,
        'error': e.toString(),
        'stackTrace': stackTrace.toString(),
      };

      // Track with custom analytics
      _customAnalytics?.trackPerformance(
        '$_componentName.$name',
        durationMs,
        properties: errorProperties,
      );

      // Track with Lukehog
      _lukehogAnalytics?.trackEvent(
        'operation',
        properties: errorProperties,
      );

      rethrow;
    }
  }
}
