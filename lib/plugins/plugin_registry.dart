import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'plugin_interface.dart';
import 'plugin_config.dart';

final pluginRegistryProvider = Provider<PluginRegistry>((ref) {
  final configs = ref.watch(pluginConfigProvider);
  final registry = PluginRegistry(configs: configs);

  ref.onDispose(() {
    registry.dispose();
  });

  return registry;
});

class PluginRegistry {
  final Map<String, PluginConfig> configs;
  final Map<String, WriteSyncPlugin> _plugins = {};
  final Map<Type, List<WriteSyncPlugin>> _pluginsByType = {};

  PluginRegistry({required this.configs});

  Future<void> registerPlugin(WriteSyncPlugin plugin) async {
    if (_plugins.containsKey(plugin.name)) {
      throw PluginException('Plugin ${plugin.name} is already registered');
    }

    final config = configs[plugin.name];
    if (config == null) {
      throw PluginException('No configuration found for plugin ${plugin.name}');
    }

    if (!config.enabled) {
      print('Plugin ${plugin.name} is disabled in configuration');
      return;
    }

    try {
      await plugin.initialize(PluginContext(config: config.options));
      _plugins[plugin.name] = plugin;

      // Register by type for faster lookups
      final type = plugin.runtimeType;
      _pluginsByType.putIfAbsent(type, () => []).add(plugin);

      print('Plugin ${plugin.name} v${plugin.version} registered successfully');
    } catch (e, stackTrace) {
      throw PluginException(
        'Failed to initialize plugin ${plugin.name}',
        e,
        stackTrace,
      );
    }
  }

  T? getPlugin<T extends WriteSyncPlugin>(String name) {
    final plugin = _plugins[name];
    return plugin is T ? plugin : null;
  }

  List<T> getPluginsOfType<T extends WriteSyncPlugin>() {
    return _pluginsByType[T]?.cast<T>() ?? [];
  }

  Future<void> dispose() async {
    for (final plugin in _plugins.values) {
      try {
        await plugin.dispose();
      } catch (e) {
        print('Error disposing plugin ${plugin.name}: $e');
      }
    }
    _plugins.clear();
    _pluginsByType.clear();
  }
}

class PluginException implements Exception {
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;

  PluginException(this.message, [this.error, this.stackTrace]);

  @override
  String toString() =>
      'PluginException: $message${error != null ? '\nError: $error' : ''}';
}
