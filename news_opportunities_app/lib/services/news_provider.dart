import 'package:flutter/foundation.dart';

import '../models/article.dart';
import 'bookmark_store.dart';
import 'news_service.dart';

/// App-wide state: current feed, selected category, and bookmarks.
class NewsProvider extends ChangeNotifier {
  NewsProvider({NewsService? service, BookmarkStore? bookmarkStore})
      : _service = service ?? NewsService(),
        _bookmarks = bookmarkStore ?? BookmarkStore();

  final NewsService _service;
  final BookmarkStore _bookmarks;

  ArticleCategory _category = ArticleCategory.general;
  List<Article> _articles = [];
  List<Article> _saved = [];
  bool _loading = false;
  String? _error;

  ArticleCategory get category => _category;
  List<Article> get articles => List.unmodifiable(_articles);
  List<Article> get saved => List.unmodifiable(_saved);
  bool get loading => _loading;
  String? get error => _error;
  bool get usingSampleData => !_service.hasApiKey;

  Future<void> init() async {
    _saved = await _bookmarks.load();
    await refresh();
  }

  Future<void> selectCategory(ArticleCategory category) async {
    if (_category == category) return;
    _category = category;
    notifyListeners();
    await refresh();
  }

  Future<void> refresh() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _articles = await _service.fetchArticles(category: _category);
    } catch (e) {
      _error = e.toString();
      _articles = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  bool isSaved(Article article) =>
      _saved.any((a) => a.url == article.url);

  Future<void> toggleSaved(Article article) async {
    if (isSaved(article)) {
      _saved.removeWhere((a) => a.url == article.url);
    } else {
      _saved = [article, ..._saved];
    }
    notifyListeners();
    await _bookmarks.save(_saved);
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}
