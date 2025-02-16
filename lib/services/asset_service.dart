import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;
import '../services/cache_service.dart';

class AssetService {
  static final AssetService instance = AssetService._();
  AssetService._();

  final _cache = CacheService.instance;
  final Map<String, String> _assetHashes = {};
  final Map<String, String> _optimizedAssets = {};

  String? getOptimizedAsset(String assetPath) {
    return _optimizedAssets[assetPath];
  }

  Future<String> processAsset(String assetPath, List<int> content) async {
    final extension = path.extension(assetPath).toLowerCase();
    final hash = sha256.convert(content).toString().substring(0, 8);

    // Check cache first
    final cacheKey = '$assetPath:$hash';
    final cached = _cache.getCachedAsset<String>(cacheKey);
    if (cached != null) {
      return cached;
    }

    String processedContent;

    switch (extension) {
      case '.css':
        processedContent = await _processCss(utf8.decode(content));
        break;
      case '.js':
        processedContent = await _processJs(utf8.decode(content));
        break;
      case '.svg':
        processedContent = await _processSvg(utf8.decode(content));
        break;
      default:
        // For other assets, just return the original content
        processedContent = base64Encode(content);
    }

    // Cache the processed content
    _cache.cacheAsset(cacheKey, processedContent);
    _assetHashes[assetPath] = hash;
    _optimizedAssets[assetPath] = processedContent;

    return processedContent;
  }

  Future<String> _processCss(String content) async {
    // Remove comments
    content = content.replaceAll(RegExp(r'/\*[\s\S]*?\*/'), '');

    // Remove whitespace
    content = content.replaceAll(RegExp(r'\s+'), ' ');

    // Remove unnecessary semicolons
    content = content.replaceAll(';}', '}');

    return content.trim();
  }

  Future<String> _processJs(String content) async {
    // Remove comments
    content = content.replaceAll(RegExp(r'//.*'), '');
    content = content.replaceAll(RegExp(r'/\*[\s\S]*?\*/'), '');

    // Remove whitespace
    content = content.replaceAll(RegExp(r'\s+'), ' ');

    return content.trim();
  }

  Future<String> _processSvg(String content) async {
    // Remove comments
    content = content.replaceAll(RegExp(r'<!--[\s\S]*?-->'), '');

    // Remove whitespace
    content = content.replaceAll(RegExp(r'>\s+<'), '><');
    content = content.replaceAll(RegExp(r'\s+'), ' ');

    return content.trim();
  }

  String getAssetHash(String assetPath) {
    return _assetHashes[assetPath] ?? '';
  }

  void clear() {
    _assetHashes.clear();
    _optimizedAssets.clear();
  }
}
