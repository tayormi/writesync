import 'dart:html';
import 'dart:js' as js;
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../config/site_config.dart';

/// Provider for the PerformanceMonitor service
final performanceMonitorProvider =
    Provider<PerformanceMonitor>((ref) => PerformanceMonitor());

class WebVitalsMetric {
  final String name;
  final double value;
  final String rating; // 'good', 'needs-improvement', 'poor'

  WebVitalsMetric({
    required this.name,
    required this.value,
    required this.rating,
  });

  @override
  String toString() => '$name: ${value.toStringAsFixed(2)} ($rating)';

  Map<String, dynamic> toJson() => {
        'name': name,
        'value': value,
        'rating': rating,
      };
}

class PerformanceMonitor {
  // Callback for metric updates
  void Function(WebVitalsMetric)? onMetricUpdated;
  bool _isAnalyticsInitialized = false;

  // Thresholds based on Google's Web Vitals recommendations
  static const Map<String, Map<String, double>> _thresholds = {
    'FCP': {'good': 1800, 'poor': 3000}, // milliseconds
    'LCP': {'good': 2500, 'poor': 4000}, // milliseconds
    'FID': {'good': 100, 'poor': 300}, // milliseconds
    'TTI': {'good': 3800, 'poor': 7300}, // milliseconds
    'CLS': {'good': 0.1, 'poor': 0.25}, // unitless
  };

  void initialize() {
    if (SiteConfig.analytics['enabled'] &&
        SiteConfig.analytics['googleAnalytics']['enabled']) {
      _initializeGoogleAnalytics();
    }
    _setupPerformanceObserver();
    _setupWebVitalsJS();
    _monitorLayoutShift();
  }

  void _initializeGoogleAnalytics() {
    if (_isAnalyticsInitialized) return;

    final measurementId =
        SiteConfig.analytics['googleAnalytics']['measurementId'];
    final debugMode = SiteConfig.analytics['googleAnalytics']['debugMode'];

    // Add GA4 script
    final gaScript = document.createElement('script') as ScriptElement;
    gaScript.src = 'https://www.googletagmanager.com/gtag/js?id=$measurementId';
    gaScript.async = true;
    document.head?.append(gaScript);

    // Initialize gtag
    js.context.callMethod('eval', [
      '''
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());
      gtag('config', '$measurementId', {
        'debug_mode': $debugMode,
        'send_page_view': true
      });
    '''
    ]);

    _isAnalyticsInitialized = true;
  }

  void _sendToGoogleAnalytics(WebVitalsMetric metric) {
    if (!SiteConfig.analytics['enabled'] ||
        !SiteConfig.analytics['googleAnalytics']['enabled'] ||
        !SiteConfig.analytics['googleAnalytics']['sendPerformanceMetrics']) {
      return;
    }

    // Send event to GA4
    js.context.callMethod('gtag', [
      'event',
      'web_vitals',
      {
        'metric_name': metric.name,
        'metric_value': metric.value,
        'metric_rating': metric.rating,
        'metric_unit': metric.name == 'CLS' ? 'unitless' : 'milliseconds',
        'metric_category': 'Web Vitals',
      }
    ]);

    // If in debug mode, log to console
    if (SiteConfig.analytics['googleAnalytics']['debugMode']) {
      print('GA Event sent: ${metric.toJson()}');
    }
  }

  void _setupPerformanceObserver() {
    js.context.callMethod('eval', [
      '''
      const observer = new PerformanceObserver((list) => {
        for (const entry of list.getEntries()) {
          if (entry.entryType === 'largest-contentful-paint') {
            window.dispatchEvent(new CustomEvent('lcp-observed', { 
              detail: { value: entry.startTime }
            }));
          }
          if (entry.entryType === 'first-input') {
            window.dispatchEvent(new CustomEvent('fid-observed', { 
              detail: { value: entry.processingStart - entry.startTime }
            }));
          }
        }
      });
      
      observer.observe({ entryTypes: ['largest-contentful-paint', 'first-input'] });
    '''
    ]);

    window.on['lcp-observed'].listen((event) {
      final value = (event as CustomEvent).detail['value'] as num;
      _logMetric('LCP', value.toDouble());
    });

    window.on['fid-observed'].listen((event) {
      final value = (event as CustomEvent).detail['value'] as num;
      _logMetric('FID', value.toDouble());
    });
  }

  void _setupWebVitalsJS() {
    // Monitor First Contentful Paint
    window.onLoad.listen((_) {
      final performance = window.performance;
      final entries = performance.getEntriesByType('paint');
      for (final entry in entries) {
        if (entry.name == 'first-contentful-paint') {
          _logMetric('FCP', entry.startTime.toDouble());
        }
      }
    });

    // Monitor Time to Interactive
    js.context.callMethod('eval', [
      '''
      let ttiPolyfill = () => {
        let lastLongTask = 0;
        let observer = new PerformanceObserver((list) => {
          for (const entry of list.getEntries()) {
            lastLongTask = Math.max(lastLongTask, entry.startTime + entry.duration);
          }
        });
        
        observer.observe({ entryTypes: ['longtask'] });
        
        setTimeout(() => {
          const navigationStart = performance.timing.navigationStart;
          const TTI = lastLongTask || (performance.timing.domInteractive - navigationStart);
          window.dispatchEvent(new CustomEvent('tti-observed', { 
            detail: { value: TTI }
          }));
        }, 5000);
      };
      
      ttiPolyfill();
    '''
    ]);

    window.on['tti-observed'].listen((event) {
      final value = (event as CustomEvent).detail['value'] as num;
      _logMetric('TTI', value.toDouble());
    });
  }

  void _monitorLayoutShift() {
    js.context.callMethod('eval', [
      '''
      let cumulativeLayoutShift = 0;
      
      new PerformanceObserver((list) => {
        for (const entry of list.getEntries()) {
          if (!entry.hadRecentInput) {
            cumulativeLayoutShift += entry.value;
            window.dispatchEvent(new CustomEvent('cls-updated', { 
              detail: { value: cumulativeLayoutShift }
            }));
          }
        }
      }).observe({ entryTypes: ['layout-shift'] });
    '''
    ]);

    window.on['cls-updated'].listen((event) {
      final value = (event as CustomEvent).detail['value'] as num;
      _logMetric('CLS', value.toDouble());
    });
  }

  String _getRating(String metric, double value) {
    final thresholds = _thresholds[metric];
    if (thresholds == null) return 'unknown';

    if (value <= thresholds['good']!) return 'good';
    if (value <= thresholds['poor']!) return 'needs-improvement';
    return 'poor';
  }

  void _logMetric(String name, double value) {
    final metric = WebVitalsMetric(
      name: name,
      value: value,
      rating: _getRating(name, value),
    );

    // Log to console in development
    print('Web Vital: $metric');

    // Notify listeners
    onMetricUpdated?.call(metric);

    // Send to analytics
    _sendToGoogleAnalytics(metric);
  }

  // Helper method to measure custom operations
  Future<T> measureOperation<T>({
    required String name,
    required Future<T> Function() operation,
  }) async {
    final startTime = DateTime.now();
    try {
      return await operation();
    } finally {
      final duration = DateTime.now().difference(startTime);
      print('Operation $name took ${duration.inMilliseconds}ms');
    }
  }

  // Track custom events with enhanced properties
  void trackEvent(
    String eventName, {
    Map<String, dynamic>? properties,
    String? category,
    String? label,
    double? value,
  }) {
    if (!_isAnalyticsEnabled() || !_isCustomEventsEnabled()) return;

    final eventData = {
      ...?properties,
      if (category != null) 'event_category': category,
      if (label != null) 'event_label': label,
      if (value != null) 'event_value': value,
      ...SiteConfig.analytics['googleAnalytics']['customDimensions'],
      'timestamp': DateTime.now().toIso8601String(),
      'page_url': window.location.href,
      'page_title': document.title,
    };

    js.context.callMethod('gtag', ['event', eventName, eventData]);

    if (SiteConfig.analytics['googleAnalytics']['debugMode']) {
      print('Custom Event: $eventName');
      print('Properties: $eventData');
    }
  }

  // Track page views with enhanced data
  void trackPageView(
      {String? title, String? path, Map<String, dynamic>? properties}) {
    if (!_isAnalyticsEnabled() ||
        !_isCustomEventsEnabled() ||
        !SiteConfig.analytics['googleAnalytics']['customEvents']
            ['trackPageViews']) {
      return;
    }

    final pageData = {
      'page_title': title ?? document.title,
      'page_path': path ?? window.location.pathname,
      'page_location': window.location.href,
      ...?properties,
      ...SiteConfig.analytics['googleAnalytics']['customDimensions'],
    };

    js.context.callMethod('gtag', ['event', 'page_view', pageData]);
  }

  // Track user interactions
  void trackInteraction(
    String element,
    String action, {
    Map<String, dynamic>? properties,
    String? category,
  }) {
    if (!_isAnalyticsEnabled() ||
        !_isCustomEventsEnabled() ||
        !SiteConfig.analytics['googleAnalytics']['customEvents']
            ['trackClicks']) {
      return;
    }

    trackEvent(
      'user_interaction',
      category: category ?? 'UI',
      properties: {
        'element': element,
        'action': action,
        ...?properties,
      },
    );
  }

  // Track search events
  void trackSearch(
    String query, {
    int? resultsCount,
    Map<String, dynamic>? properties,
  }) {
    if (!_isAnalyticsEnabled() ||
        !_isCustomEventsEnabled() ||
        !SiteConfig.analytics['googleAnalytics']['customEvents']
            ['trackSearch']) {
      return;
    }

    trackEvent(
      'search',
      properties: {
        'search_term': query,
        if (resultsCount != null) 'results_count': resultsCount,
        ...?properties,
      },
    );
  }

  // Track error events
  void trackError(
    String error, {
    String? type,
    StackTrace? stackTrace,
    Map<String, dynamic>? properties,
  }) {
    if (!_isAnalyticsEnabled() ||
        !_isCustomEventsEnabled() ||
        !SiteConfig.analytics['googleAnalytics']['customEvents']
            ['trackErrors']) {
      return;
    }

    trackEvent(
      'error',
      category: 'Error',
      properties: {
        'error_message': error,
        if (type != null) 'error_type': type,
        if (stackTrace != null) 'stack_trace': stackTrace.toString(),
        ...?properties,
      },
    );
  }

  // Helper methods for checking analytics state
  bool _isAnalyticsEnabled() {
    return SiteConfig.analytics['enabled'] &&
        SiteConfig.analytics['googleAnalytics']['enabled'];
  }

  bool _isCustomEventsEnabled() {
    return SiteConfig.analytics['googleAnalytics']['customEvents']['enabled'];
  }
}
