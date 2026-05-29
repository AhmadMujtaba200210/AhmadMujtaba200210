import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/article.dart';
import '../services/news_provider.dart';
import '../widgets/article_card.dart';
import 'article_detail_screen.dart';

/// The main scrollable feed with category filters.
class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _CategoryBar(),
        const _SampleDataBanner(),
        Expanded(
          child: Consumer<NewsProvider>(
            builder: (context, provider, _) {
              if (provider.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (provider.error != null) {
                return _ErrorView(
                  message: provider.error!,
                  onRetry: provider.refresh,
                );
              }
              if (provider.articles.isEmpty) {
                return const _EmptyView();
              }
              return RefreshIndicator(
                onRefresh: provider.refresh,
                child: ListView.builder(
                  itemCount: provider.articles.length,
                  itemBuilder: (context, index) {
                    final article = provider.articles[index];
                    return ArticleCard(
                      article: article,
                      saved: provider.isSaved(article),
                      onToggleSaved: () => provider.toggleSaved(article),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ArticleDetailScreen(article: article),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NewsProvider>();
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: ArticleCategory.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = ArticleCategory.values[index];
          return ChoiceChip(
            label: Text(category.label),
            selected: provider.category == category,
            onSelected: (_) => provider.selectCategory(category),
          );
        },
      ),
    );
  }
}

class _SampleDataBanner extends StatelessWidget {
  const _SampleDataBanner();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NewsProvider>();
    if (!provider.usingSampleData) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      color: theme.colorScheme.tertiaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        'Showing sample data. Pass --dart-define=NEWS_API_KEY=... to load live news.',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onTertiaryContainer,
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          'No articles found for this category yet.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
