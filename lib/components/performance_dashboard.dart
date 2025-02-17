import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../services/performance_monitor.dart';
import 'dart:convert';
import 'dart:html' show AnchorElement, document;

final metricsProvider = StateProvider<List<WebVitalsMetric>>((ref) => []);
final historicalMetricsProvider =
    StateProvider<Map<String, List<WebVitalsMetric>>>((ref) => {});
final isMinimizedProvider = StateProvider<bool>((ref) => false);

class PerformanceDashboard extends StatefulComponent {
  const PerformanceDashboard();

  @override
  State<PerformanceDashboard> createState() => _PerformanceDashboardState();
}

class _PerformanceDashboardState extends State<PerformanceDashboard> {
  static const int maxHistorySize = 50; // Keep last 50 measurements per metric

  @override
  void initState() {
    super.initState();
    _setupMetricsListener();
  }

  void _setupMetricsListener() {
    final monitor = context.read(performanceMonitorProvider);
    monitor.onMetricUpdated = (metric) {
      // Update current metrics
      final metrics = [...context.read(metricsProvider)];
      final existingIndex = metrics.indexWhere((m) => m.name == metric.name);

      if (existingIndex != -1) {
        metrics[existingIndex] = metric;
      } else {
        metrics.add(metric);
      }
      context.read(metricsProvider.notifier).state = metrics;

      // Update historical data
      final history = Map<String, List<WebVitalsMetric>>.from(
          context.read(historicalMetricsProvider));
      if (!history.containsKey(metric.name)) {
        history[metric.name] = [];
      }
      history[metric.name] = [
        metric,
        ...history[metric.name]!.take(maxHistorySize - 1)
      ];
      context.read(historicalMetricsProvider.notifier).state = history;
    };
  }

  String _getColorForRating(String rating) {
    switch (rating) {
      case 'good':
        return 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300';
      case 'needs-improvement':
        return 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-300';
      case 'poor':
        return 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-300';
      default:
        return 'bg-gray-100 text-gray-800 dark:bg-gray-900 dark:text-gray-300';
    }
  }

  String _getMetricDescription(String name) {
    switch (name) {
      case 'FCP':
        return 'First Contentful Paint - Time until the first content is painted';
      case 'LCP':
        return 'Largest Contentful Paint - Time until the largest content is painted';
      case 'FID':
        return 'First Input Delay - Time until the page can respond to user input';
      case 'TTI':
        return 'Time to Interactive - Time until the page becomes fully interactive';
      case 'CLS':
        return 'Cumulative Layout Shift - Measures visual stability';
      default:
        return '';
    }
  }

  String _getAverageValue(String metricName, List<WebVitalsMetric> history) {
    if (history.isEmpty) return 'N/A';
    final sum = history.fold(0.0, (sum, metric) => sum + metric.value);
    final avg = sum / history.length;
    return metricName == 'CLS'
        ? avg.toStringAsFixed(3)
        : '${avg.toStringAsFixed(0)}ms';
  }

  void _exportMetrics() {
    final history = context.read(historicalMetricsProvider);
    final exportData = {
      'timestamp': DateTime.now().toIso8601String(),
      'metrics': history.map((key, value) => MapEntry(key, {
            'current': value.first.value,
            'average':
                value.fold(0.0, (sum, m) => sum + m.value) / value.length,
            'history': value
                .map((m) => {
                      'value': m.value,
                      'rating': m.rating,
                      'timestamp': DateTime.now().toIso8601String(),
                    })
                .toList(),
          })),
    };

    final jsonData = jsonEncode(exportData);
    final encodedData = Uri.encodeComponent(jsonData);
    final link = document.createElement('a') as AnchorElement;
    link.href = 'data:text/json;charset=utf-8,$encodedData';
    link.download =
        'performance_metrics_${DateTime.now().toIso8601String()}.json';
    link.click();
  }

  @override
  Iterable<Component> build(BuildContext context) sync* {
    final metrics = context.watch(metricsProvider);
    final history = context.watch(historicalMetricsProvider);
    final isMinimized = context.watch(isMinimizedProvider);

    yield div(
      classes: '''
        fixed ${isMinimized ? 'bottom-4 right-4 w-auto' : 'bottom-4 right-4 w-96 max-w-full'}
        transition-all duration-300 ease-in-out
      ''',
      [
        div(
          classes: '''
            bg-white dark:bg-gray-800 rounded-lg shadow-lg 
            border border-gray-200 dark:border-gray-700
            ${isMinimized ? 'p-2' : 'p-4'}
          ''',
          [
            // Header
            div(
              classes: 'flex justify-between items-center mb-4',
              [
                if (!isMinimized)
                  h3(
                    classes:
                        'text-lg font-semibold text-gray-900 dark:text-white',
                    [text('Performance Metrics')],
                  ),
                div(
                  classes: 'flex items-center gap-2',
                  [
                    if (!isMinimized) ...[
                      button(
                        classes: '''
                          text-gray-500 hover:text-gray-700 dark:text-gray-400 
                          dark:hover:text-gray-200 transition-colors
                        ''',
                        events: {
                          'click': (event) => _exportMetrics(),
                        },
                        [text('Export')],
                      ),
                      button(
                        classes: '''
                          text-gray-500 hover:text-gray-700 dark:text-gray-400 
                          dark:hover:text-gray-200 transition-colors
                        ''',
                        events: {
                          'click': (event) {
                            context.read(metricsProvider.notifier).state = [];
                            context
                                .read(historicalMetricsProvider.notifier)
                                .state = {};
                          },
                        },
                        [text('Reset')],
                      ),
                    ],
                    button(
                      classes: '''
                        text-gray-500 hover:text-gray-700 dark:text-gray-400 
                        dark:hover:text-gray-200 transition-colors
                      ''',
                      events: {
                        'click': (event) {
                          context.read(isMinimizedProvider.notifier).state =
                              !isMinimized;
                        },
                      },
                      [
                        text(isMinimized ? 'Expand' : 'Minimize'),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            if (!isMinimized)
              // Metrics List
              div(
                classes: 'space-y-3',
                [
                  if (metrics.isEmpty)
                    p(
                      classes:
                          'text-gray-500 dark:text-gray-400 text-center py-4',
                      [text('Collecting metrics...')],
                    )
                  else
                    for (final metric in metrics)
                      div(
                        classes:
                            'border border-gray-100 dark:border-gray-700 rounded-lg p-3',
                        [
                          // Metric Header
                          div(
                            classes: 'flex justify-between items-center mb-2',
                            [
                              span(
                                classes:
                                    'font-medium text-gray-900 dark:text-white',
                                [text(metric.name)],
                              ),
                              span(
                                classes: '''
                                  px-2 py-1 text-xs font-medium rounded-full
                                  ${_getColorForRating(metric.rating)}
                                ''',
                                [text(metric.rating)],
                              ),
                            ],
                          ),
                          // Current and Average Values
                          div(
                            classes:
                                'flex justify-between text-sm text-gray-600 dark:text-gray-300 mb-1',
                            [
                              div([
                                text('Current: '),
                                text(
                                  metric.name == 'CLS'
                                      ? metric.value.toStringAsFixed(3)
                                      : '${metric.value.toStringAsFixed(0)}ms',
                                ),
                              ]),
                              if (history.containsKey(metric.name))
                                div([
                                  text('Avg: '),
                                  text(_getAverageValue(
                                      metric.name, history[metric.name]!)),
                                ]),
                            ],
                          ),
                          // Metric Description
                          p(
                            classes: 'text-xs text-gray-500 dark:text-gray-400',
                            [text(_getMetricDescription(metric.name))],
                          ),
                        ],
                      ),
                ],
              )
            else
              // Minimized view - just show status indicators
              div(
                classes: 'flex gap-2',
                [
                  for (final metric in metrics)
                    div(
                      classes: '''
                        w-3 h-3 rounded-full
                        ${_getColorForRating(metric.rating)}
                      ''',
                      attributes: {
                        'title':
                            '${metric.name}: ${metric.value.toStringAsFixed(metric.name == 'CLS' ? 3 : 0)}${metric.name == 'CLS' ? '' : 'ms'}',
                      },
                      [],
                    ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
