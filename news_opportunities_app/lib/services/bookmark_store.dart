import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/article.dart';

/// Persists the user's saved articles to device storage.
class BookmarkStore {
  static const _key = 'bookmarked_articles';

  Future<List<Article>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? const [];
    return raw
        .map((s) => Article.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  Future<void> save(List<Article> articles) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = articles.map((a) => jsonEncode(a.toJson())).toList();
    await prefs.setStringList(_key, raw);
  }
}
