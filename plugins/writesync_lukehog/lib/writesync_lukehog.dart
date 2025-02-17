import 'package:writesync/plugins/plugin_interface.dart';
import 'package:writesync/plugins/plugin_package.dart';
import 'src/lukehog_plugin.dart';
import 'src/lukehog_schema.dart';

/// Lukehog analytics plugin for WriteSync
final lukehogPlugin = PluginPackage(
  name: 'lukehog_analytics',
  version: '1.0.0',
  description: 'Lukehog analytics integration for WriteSync',
  author: 'Your Name',
  homepage: 'https://github.com/yourusername/writesync-lukehog',
  dependencies: ['lukehog_client: ^1.0.0'],
  schema: LukehogAnalyticsSchema(),
  pluginType: AnalyticsPlugin,
  createPlugin: () => LukehogAnalyticsPlugin(),
);

/// Register the plugin with WriteSync
void registerPlugin() {
  PluginPackageRegistry.register(lukehogPlugin);
}
