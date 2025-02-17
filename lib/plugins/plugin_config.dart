import 'dart:convert';
import 'dart:html';
import 'package:js/js.dart';
import 'package:yaml/yaml.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';

@JS()
@anonymous
class JsPluginConfig {
  external Map<String, dynamic>? get plugins;
}

@JS('pluginConfigs')
external JsPluginConfig get pluginConfigs;

/// Base configuration for all plugins
class PluginConfig {
  final String name;
  final bool enabled;
  final bool developmentOnly;
  final Map<String, dynamic> options;

  const PluginConfig({
    required this.name,
    this.enabled = true,
    this.developmentOnly = false,
    this.options = const {},
  });

  factory PluginConfig.fromJson(Map<String, dynamic> json) {
    return PluginConfig(
      name: json['name'] as String,
      enabled: json['enabled'] as bool? ?? true,
      developmentOnly: json['development_only'] as bool? ?? false,
      options: json['options'] as Map<String, dynamic>? ?? {},
    );
  }

  factory PluginConfig.fromYaml(String name, YamlMap yaml) {
    return PluginConfig(
      name: name,
      enabled: yaml['enabled'] as bool? ?? true,
      developmentOnly: yaml['development_only'] as bool? ?? false,
      options: _convertYamlMap(yaml['options'] as YamlMap?),
    );
  }

  static Map<String, dynamic> _convertYamlMap(YamlMap? yaml) {
    if (yaml == null) return {};
    return json.decode(json.encode(yaml)) as Map<String, dynamic>;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'enabled': enabled,
        'development_only': developmentOnly,
        'options': options,
      };

  /// Merge this config with another, with the other taking precedence
  PluginConfig merge(PluginConfig other) {
    return PluginConfig(
      name: name,
      enabled: other.enabled,
      developmentOnly: other.developmentOnly,
      options: {
        ...options,
        ...other.options,
      },
    );
  }
}

/// Provider for plugin configurations
final pluginConfigProvider = Provider<Map<String, PluginConfig>>((ref) {
  // Default configurations
  return {
    'lukehog_analytics': PluginConfig(
      name: 'lukehog_analytics',
      enabled: true,
      options: {
        'projectId': 'HypnhnNIEIycLTTa',
        'debug': false,
        'automaticPageviews': true,
        'automaticErrorTracking': true,
        'sessionExpiration': 1800,
        'events': {
          'pageView': {
            'enabled': true,
            'properties': [
              'url',
              'title',
              'referrer',
              'deviceType',
              'browserInfo',
            ],
          },
          'error': {
            'enabled': true,
            'properties': [
              'message',
              'stackTrace',
              'errorType',
              'url',
            ],
          },
          'interaction': {
            'enabled': true,
            'properties': [
              'elementId',
              'elementType',
              'action',
              'value',
            ],
          },
        },
        'retry': {
          'maxAttempts': 3,
          'initialDelay': 1000,
          'maxDelay': 5000,
        },
        'batch': {
          'enabled': true,
          'maxSize': 10,
          'flushInterval': 30000,
        },
        'storage': {
          'prefix': 'lh_',
          'maxItems': 1000,
          'maxAge': 604800,
        },
      },
    ),
  };
});

class PluginConfigLoader {
  static Map<String, PluginConfig> loadFromYaml(String yamlContent) {
    final yaml = loadYaml(yamlContent) as YamlMap;
    final plugins = yaml['plugins'] as YamlMap?;

    if (plugins == null) return {};

    return Map.fromEntries(
      plugins.entries.map((entry) => MapEntry(
            entry.key as String,
            PluginConfig.fromYaml(entry.key as String, entry.value as YamlMap),
          )),
    );
  }

  /// Load all plugin configurations
  static Map<String, PluginConfig> load() {
    try {
      final configs = <String, PluginConfig>{};

      // Load configurations from injected JavaScript object
      final jsConfig = pluginConfigs;
      final pluginsData = jsConfig.plugins;

      if (pluginsData != null) {
        configs.addAll(
          pluginsData.map(
            (key, value) => MapEntry(
              key,
              PluginConfig.fromJson({
                'name': key,
                ...value as Map<String, dynamic>,
              }),
            ),
          ),
        );
      }

      if (configs.isEmpty) {
        print('Warning: No plugin configurations found, using defaults');
        return {
          'lukehog_analytics': PluginConfig(
            name: 'lukehog_analytics',
            enabled: true,
            options: {
              'projectId':
                  PluginEnvironment.getEnvVar('LUKEHOG_PROJECT_ID') ?? '',
              'debug': false,
              'automaticPageviews': true,
              'automaticErrorTracking': true,
            },
          ),
        };
      }

      return configs;
    } catch (e, stack) {
      print('Error loading plugin configs: $e');
      print('Stack trace: $stack');
      return {};
    }
  }
}

/// Environment configuration for plugins
class PluginEnvironment {
  static bool get isDevelopment {
    return const bool.fromEnvironment('DEVELOPMENT', defaultValue: false);
  }

  static String? getEnvVar(String name) {
    return (window as dynamic).env?[name];
  }

  static void setEnvVar(String name, String value) {
    if ((window as dynamic).env == null) {
      (window as dynamic).env = {};
    }
    (window as dynamic).env[name] = value;
  }
}
