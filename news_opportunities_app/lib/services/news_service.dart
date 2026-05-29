import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/article.dart';

/// Fetches news and opportunities from a NewsAPI-compatible backend.
///
/// Provide an API key at build time:
///   flutter run --dart-define=NEWS_API_KEY=your_key_here
///
/// When no key is supplied the service falls back to a bundled set of
/// sample articles so the UI is fully explorable offline.
class NewsService {
  NewsService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _apiKey =
      String.fromEnvironment('NEWS_API_KEY', defaultValue: '');
  static const String _baseUrl = 'https://newsapi.org/v2';

  bool get hasApiKey => _apiKey.isNotEmpty;

  /// Returns the latest articles for the given [category].
  Future<List<Article>> fetchArticles({
    ArticleCategory category = ArticleCategory.general,
    String country = 'us',
  }) async {
    if (!hasApiKey) {
      return _sampleArticles(category);
    }

    final query = _queryFor(category);
    final uri = query == null
        ? Uri.parse(
            '$_baseUrl/top-headlines?country=$country&apiKey=$_apiKey',
          )
        : Uri.parse(
            '$_baseUrl/everything?q=$query&sortBy=publishedAt&language=en&apiKey=$_apiKey',
          );

    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw NewsServiceException(
        'Request failed (${response.statusCode}): ${response.reasonPhrase}',
      );
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final articles = (body['articles'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((json) => Article.fromJson(json, category: category))
        .where((a) => a.url.isNotEmpty)
        .toList();
    return articles;
  }

  /// Maps a category to a search term, or null for plain top headlines.
  String? _queryFor(ArticleCategory category) {
    switch (category) {
      case ArticleCategory.general:
        return null;
      case ArticleCategory.jobs:
        return 'jobs OR hiring OR careers';
      case ArticleCategory.scholarships:
        return 'scholarship OR fellowship OR grant';
      case ArticleCategory.internships:
        return 'internship OR "summer program"';
      case ArticleCategory.events:
        return 'conference OR hackathon OR meetup';
      case ArticleCategory.technology:
        return 'technology';
      case ArticleCategory.business:
        return 'business';
    }
  }

  List<Article> _sampleArticles(ArticleCategory category) {
    final now = DateTime.now();
    final seed = <Article>[
      Article(
        title: 'Global Scholarship Fund Opens 2026 Applications',
        description:
            'A new \$50M fund is accepting applications from graduate '
            'students in STEM and quantitative finance worldwide.',
        url: 'https://example.com/scholarship-2026',
        source: 'Opportunities Daily',
        publishedAt: now.subtract(const Duration(hours: 2)),
        category: ArticleCategory.scholarships,
      ),
      Article(
        title: 'Top Fintech Firms Announce Summer Internship Cohorts',
        description:
            'Leading trading and fintech companies expand their 2026 '
            'internship programs with remote-first options.',
        url: 'https://example.com/internships-2026',
        source: 'Career Wire',
        publishedAt: now.subtract(const Duration(hours: 5)),
        category: ArticleCategory.internships,
      ),
      Article(
        title: 'Quant Developer Roles Surge as Markets Embrace AI',
        description:
            'Hiring for quantitative developers and ML engineers grows '
            '30% year over year across major financial hubs.',
        url: 'https://example.com/quant-jobs',
        source: 'Market Pulse',
        publishedAt: now.subtract(const Duration(hours: 8)),
        category: ArticleCategory.jobs,
      ),
      Article(
        title: 'International Hackathon Series Returns This Fall',
        description:
            'A 48-hour global hackathon invites builders to ship '
            'open-source tools for financial inclusion.',
        url: 'https://example.com/hackathon',
        source: 'Events Hub',
        publishedAt: now.subtract(const Duration(hours: 12)),
        category: ArticleCategory.events,
      ),
      Article(
        title: 'Breakthrough in On-Device Machine Learning Announced',
        description:
            'Researchers demonstrate faster inference on mobile hardware, '
            'opening the door to smarter offline apps.',
        url: 'https://example.com/on-device-ml',
        source: 'Tech Today',
        publishedAt: now.subtract(const Duration(hours: 1)),
        category: ArticleCategory.technology,
      ),
    ];

    if (category == ArticleCategory.general) return seed;
    return seed.where((a) => a.category == category).toList();
  }

  void dispose() => _client.close();
}

class NewsServiceException implements Exception {
  NewsServiceException(this.message);
  final String message;

  @override
  String toString() => 'NewsServiceException: $message';
}
