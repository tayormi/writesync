import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../config/site_config.dart';
import '../services/services.dart';
import '../plugins/plugin_interface.dart';
import '../plugins/plugin_registry.dart';

mixin MonitoringMixin<T extends StatefulComponent> on State<T> {
  PerformanceMonitor? _monitor;
  PluginRegistry? _pluginRegistry;
  String get _componentName => T.toString();

  @override
  void initState() {
    super.initState();
    if (SiteConfig.enablePerformanceMonitoring) {
      _monitor = context.read(performanceMonitorProvider);
      _pluginRegistry = context.read(pluginRegistryProvider);
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

    // Track with performance monitor
    _monitor?.trackEvent(
      'component_event',
      category: 'Component',
      label: action,
      properties: eventProperties,
    );

    // Track with analytics plugins
    for (final plugin
        in _pluginRegistry?.getPluginsOfType<AnalyticsPlugin>() ?? []) {
      plugin.trackEvent(
        'component_event',
        properties: eventProperties,
      );
    }
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

    // Track with performance monitor
    _monitor?.trackError(
      error,
      type: type ?? 'ComponentError',
      stackTrace: stackTrace,
      properties: errorProperties,
    );

    // Track with analytics plugins
    for (final plugin
        in _pluginRegistry?.getPluginsOfType<AnalyticsPlugin>() ?? []) {
      plugin.trackError(
        error,
        type: type,
        stackTrace: stackTrace,
        properties: errorProperties,
      );
    }
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

    // Track with performance monitor
    _monitor?.trackInteraction(
      element,
      action,
      category: _componentName,
      properties: properties,
    );

    // Track with analytics plugins
    for (final plugin
        in _pluginRegistry?.getPluginsOfType<AnalyticsPlugin>() ?? []) {
      plugin.trackEvent(
        'interaction',
        properties: interactionProperties,
      );
    }
  }

  void _trackComponentMount() {
    final mountProperties = {
      'component': _componentName,
      'timestamp': DateTime.now().toIso8601String(),
      'action': 'mount',
    };

    // Track with performance monitor
    _monitor?.trackEvent(
      'component_lifecycle',
      category: 'Component',
      label: 'mount',
      properties: mountProperties,
    );

    // Track with analytics plugins
    for (final plugin
        in _pluginRegistry?.getPluginsOfType<AnalyticsPlugin>() ?? []) {
      plugin.trackEvent(
        'component_lifecycle',
        properties: mountProperties,
      );
    }
  }

  void _trackComponentUnmount() {
    final unmountProperties = {
      'component': _componentName,
      'timestamp': DateTime.now().toIso8601String(),
      'action': 'unmount',
    };

    // Track with performance monitor
    _monitor?.trackEvent(
      'component_lifecycle',
      category: 'Component',
      label: 'unmount',
      properties: unmountProperties,
    );

    // Track with analytics plugins
    for (final plugin
        in _pluginRegistry?.getPluginsOfType<AnalyticsPlugin>() ?? []) {
      plugin.trackEvent(
        'component_lifecycle',
        properties: unmountProperties,
      );
    }
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

      // Track with analytics plugins
      for (final plugin
          in _pluginRegistry?.getPluginsOfType<AnalyticsPlugin>() ?? []) {
        plugin.trackEvent(
          'operation',
          properties: successProperties,
        );
      }

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

      // Track with analytics plugins
      for (final plugin
          in _pluginRegistry?.getPluginsOfType<AnalyticsPlugin>() ?? []) {
        plugin.trackEvent(
          'operation',
          properties: errorProperties,
        );
      }

      rethrow;
    }
  }
}
