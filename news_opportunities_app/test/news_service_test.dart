import 'package:flutter_test/flutter_test.dart';
import 'package:news_opportunities_app/models/article.dart';
import 'package:news_opportunities_app/services/news_service.dart';

void main() {
  group('Article.fromJson', () {
    test('parses a NewsAPI payload', () {
      final article = Article.fromJson({
        'title': 'Hello World',
        'description': 'A description',
        'url': 'https://example.com',
        'urlToImage': 'https://example.com/img.png',
        'source': {'name': 'Example'},
        'author': 'Jane Doe',
        'publishedAt': '2026-05-29T10:00:00Z',
      }, category: ArticleCategory.jobs);

      expect(article.title, 'Hello World');
      expect(article.source, 'Example');
      expect(article.category, ArticleCategory.jobs);
      expect(article.publishedAt, isNotNull);
    });

    test('falls back to sensible defaults', () {
      final article = Article.fromJson({});
      expect(article.title, 'Untitled');
      expect(article.url, '');
      expect(article.category, ArticleCategory.general);
    });

    test('round-trips through toJson', () {
      final original = Article.fromJson({
        'title': 'Round Trip',
        'url': 'https://example.com/rt',
        'source': {'name': 'RT'},
      });
      final restored = Article.fromJson(original.toJson());
      expect(restored.title, original.title);
      expect(restored.url, original.url);
      expect(restored.source, original.source);
    });
  });

  group('NewsService sample data', () {
    test('returns sample articles when no API key is configured', () async {
      final service = NewsService();
      // No NEWS_API_KEY is defined in the test environment.
      expect(service.hasApiKey, isFalse);

      final all = await service.fetchArticles();
      expect(all, isNotEmpty);

      final jobs =
          await service.fetchArticles(category: ArticleCategory.jobs);
      expect(jobs.every((a) => a.category == ArticleCategory.jobs), isTrue);

      service.dispose();
    });
  });
}
