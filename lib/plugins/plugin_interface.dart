/// Context provided to plugins with access to configuration
class PluginContext {
  final Map<String, dynamic> config;

  const PluginContext({
    required this.config,
  });
}

/// Base interface for all WriteSync plugins
abstract class WriteSyncPlugin {
  /// Unique name of the plugin
  String get name;

  /// Plugin version
  String get version;

  /// Plugin description
  String get description;

  /// Called when the plugin is initialized
  Future<void> initialize(PluginContext context);

  /// Called when the plugin is being disposed
  Future<void> dispose();

  /// Called before the build process starts
  Future<void> onBeforeBuild() async {}

  /// Called after the build process completes
  Future<void> onAfterBuild() async {}

  /// Called before a blog post is processed
  Future<void> onBeforePostProcess(String content) async {}

  /// Called after a blog post is processed
  Future<void> onAfterPostProcess(String content) async {}

  /// Called before assets are processed
  Future<void> onBeforeAssetProcess(List<String> assets) async {}

  /// Called after assets are processed
  Future<void> onAfterAssetProcess(List<String> assets) async {}
}

/// Base class for analytics plugins
abstract class AnalyticsPlugin extends WriteSyncPlugin {
  void trackEvent(String name, {Map<String, dynamic>? properties});
  void trackPageView(String path, {Map<String, dynamic>? properties});
  void trackError(String error,
      {String? type, StackTrace? stackTrace, Map<String, dynamic>? properties});
  void setUserId(String? userId);
}

/// Base class for content processor plugins
abstract class ContentProcessorPlugin extends WriteSyncPlugin {
  Future<String> processMarkdown(String content);
  Future<String> processHtml(String content);
}

/// Base class for asset processor plugins
abstract class AssetProcessorPlugin extends WriteSyncPlugin {
  Future<List<int>> processAsset(String path, List<int> content);
  bool canProcessAsset(String path);
}

/// Base class for search plugins
abstract class SearchPlugin extends WriteSyncPlugin {
  Future<void> indexPost(String content);
  Future<List<String>> search(String query);
}

/// Exception thrown by plugins
class PluginException implements Exception {
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;

  PluginException(this.message, [this.error, this.stackTrace]);

  @override
  String toString() =>
      'PluginException: $message${error != null ? '\nError: $error' : ''}';
}
