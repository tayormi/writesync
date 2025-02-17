import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/blog_post.dart';

class CacheService {
  static final CacheService instance = CacheService._();
  CacheService._();

  final Map<String, BlogPost> _postCache = {};
  final Map<String, String> _contentHashes = {};
  final Map<String, dynamic> _assetCache = {};

  BlogPost? getCachedPost(String slug) => _postCache[slug];

  void cachePost(BlogPost post) {
    _postCache[post.slug] = post;
  }

  bool hasContentChanged(String path, String content) {
    final hash = sha256.convert(utf8.encode(content)).toString();
    final hasChanged = _contentHashes[path] != hash;
    _contentHashes[path] = hash;
    return hasChanged;
  }

  T? getCachedAsset<T>(String key) => _assetCache[key] as T?;

  void cacheAsset<T>(String key, T asset) {
    _assetCache[key] = asset;
  }

  void clearCache() {
    _postCache.clear();
    _contentHashes.clear();
    _assetCache.clear();
  }
}
