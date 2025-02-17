import 'package:meta/meta.dart';
import 'plugin_interface.dart';
import 'plugin_schema.dart';

/// Represents a plugin package that can be installed
class PluginPackage {
  final String name;
  final String version;
  final String description;
  final String author;
  final String homepage;
  final List<String> dependencies;
  final PluginSchema schema;
  final Type pluginType;
  final WriteSyncPlugin Function() createPlugin;

  const PluginPackage({
    required this.name,
    required this.version,
    required this.description,
    required this.author,
    required this.homepage,
    this.dependencies = const [],
    required this.schema,
    required this.pluginType,
    required this.createPlugin,
  });

  /// Generate package manifest
  Map<String, dynamic> toManifest() => {
        'name': name,
        'version': version,
        'description': description,
        'author': author,
        'homepage': homepage,
        'dependencies': dependencies,
        'type': pluginType.toString(),
      };

  /// Generate package documentation
  String generateDocs() => schema.generateDocs();

  /// Create plugin instance
  WriteSyncPlugin instantiate() => createPlugin();
}

/// Registry for available plugin packages
class PluginPackageRegistry {
  static final Map<String, PluginPackage> _packages = {};

  /// Register a plugin package
  static void register(PluginPackage package) {
    _packages[package.name] = package;
  }

  /// Get a plugin package by name
  static PluginPackage? getPackage(String name) => _packages[name];

  /// Get all registered packages
  static List<PluginPackage> get packages => _packages.values.toList();

  /// Get packages of a specific type
  static List<PluginPackage> getPackagesOfType<T extends WriteSyncPlugin>() {
    return _packages.values.where((p) => p.pluginType == T).toList();
  }
}

/// Plugin package manifest file format
@immutable
class PluginManifest {
  final String name;
  final String version;
  final String description;
  final String author;
  final String homepage;
  final List<String> dependencies;
  final String type;
  final Map<String, dynamic> config;

  const PluginManifest({
    required this.name,
    required this.version,
    required this.description,
    required this.author,
    required this.homepage,
    required this.dependencies,
    required this.type,
    required this.config,
  });

  factory PluginManifest.fromJson(Map<String, dynamic> json) {
    return PluginManifest(
      name: json['name'] as String,
      version: json['version'] as String,
      description: json['description'] as String,
      author: json['author'] as String,
      homepage: json['homepage'] as String,
      dependencies: (json['dependencies'] as List<dynamic>).cast<String>(),
      type: json['type'] as String,
      config: json['config'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'version': version,
        'description': description,
        'author': author,
        'homepage': homepage,
        'dependencies': dependencies,
        'type': type,
        'config': config,
      };
}

/// Example plugin package:
/// ```dart
/// final lukehogPlugin = PluginPackage(
///   name: 'lukehog_analytics',
///   version: '1.0.0',
///   description: 'Lukehog analytics integration for WriteSync',
///   author: 'Your Name',
///   homepage: 'https://github.com/yourusername/writesync-lukehog',
///   dependencies: ['lukehog_client: ^1.0.0'],
///   schema: LukehogAnalyticsSchema(),
///   pluginType: AnalyticsPlugin,
///   createPlugin: () => LukehogAnalyticsPlugin(),
/// );
/// 
/// // Register the plugin package
/// PluginPackageRegistry.register(lukehogPlugin);
/// ```
/// 
/// Plugin directory structure:
/// ```
/// writesync_lukehog/
/// ├── lib/
/// │   ├── src/
/// │   │   ├── lukehog_plugin.dart
/// │   │   └── lukehog_schema.dart
/// │   └── writesync_lukehog.dart
/// ├── config/
/// │   └── default.yaml
/// ├── pubspec.yaml
/// ├── README.md
/// └── LICENSE
/// ``` 