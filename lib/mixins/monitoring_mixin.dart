import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../services/performance_monitor.dart';
import '../config/site_config.dart';

mixin MonitoringMixin<T extends StatefulComponent> on State<T> {
  PerformanceMonitor? _monitor;
  String get _componentName => T.toString();

  @override
  void initState() {
    super.initState();
    if (SiteConfig.enablePerformanceMonitoring) {
      _monitor = context.read(performanceMonitorProvider);
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
    _monitor?.trackEvent(
      'component_event',
      category: 'Component',
      label: action,
      properties: {
        'component': _componentName,
        ...?properties,
      },
    );
  }

  void trackComponentError(
    String error, {
    String? type,
    StackTrace? stackTrace,
    Map<String, dynamic>? properties,
  }) {
    _monitor?.trackError(
      error,
      type: type ?? 'ComponentError',
      stackTrace: stackTrace,
      properties: {
        'component': _componentName,
        ...?properties,
      },
    );
  }

  void trackComponentInteraction(
    String element,
    String action, {
    Map<String, dynamic>? properties,
  }) {
    _monitor?.trackInteraction(
      element,
      action,
      category: _componentName,
      properties: properties,
    );
  }

  void _trackComponentMount() {
    _monitor?.trackEvent(
      'component_lifecycle',
      category: 'Component',
      label: 'mount',
      properties: {
        'component': _componentName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  void _trackComponentUnmount() {
    _monitor?.trackEvent(
      'component_lifecycle',
      category: 'Component',
      label: 'unmount',
      properties: {
        'component': _componentName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<T> trackOperation<T>(String name, Future<T> Function() operation) {
    return _monitor?.measureOperation(
          name: '$_componentName.$name',
          operation: operation,
        ) ??
        operation();
  }
}
