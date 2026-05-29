/// Domain model representing a single news article or opportunity.
class Article {
  final String title;
  final String? description;
  final String url;
  final String? imageUrl;
  final String? source;
  final String? author;
  final DateTime? publishedAt;
  final ArticleCategory category;

  const Article({
    required this.title,
    required this.url,
    this.description,
    this.imageUrl,
    this.source,
    this.author,
    this.publishedAt,
    this.category = ArticleCategory.general,
  });

  /// Builds an [Article] from a NewsAPI-style JSON payload.
  factory Article.fromJson(
    Map<String, dynamic> json, {
    ArticleCategory category = ArticleCategory.general,
  }) {
    final source = json['source'];
    return Article(
      title: (json['title'] as String?)?.trim() ?? 'Untitled',
      description: json['description'] as String?,
      url: json['url'] as String? ?? '',
      imageUrl: json['urlToImage'] as String?,
      source: source is Map<String, dynamic> ? source['name'] as String? : null,
      author: json['author'] as String?,
      publishedAt: DateTime.tryParse(json['publishedAt'] as String? ?? ''),
      category: category,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'url': url,
        'urlToImage': imageUrl,
        'source': {'name': source},
        'author': author,
        'publishedAt': publishedAt?.toIso8601String(),
        'category': category.name,
      };
}

/// High-level buckets used to filter the feed.
enum ArticleCategory {
  general,
  jobs,
  scholarships,
  internships,
  events,
  technology,
  business;

  String get label {
    switch (this) {
      case ArticleCategory.general:
        return 'Top Stories';
      case ArticleCategory.jobs:
        return 'Jobs';
      case ArticleCategory.scholarships:
        return 'Scholarships';
      case ArticleCategory.internships:
        return 'Internships';
      case ArticleCategory.events:
        return 'Events';
      case ArticleCategory.technology:
        return 'Technology';
      case ArticleCategory.business:
        return 'Business';
    }
  }
}
