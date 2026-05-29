import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/article.dart';

/// Full-screen reading view for a single article.
class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(article.source ?? 'Article')),
      body: ListView(
        children: [
          if (article.imageUrl != null)
            CachedNetworkImage(
              imageUrl: article.imageUrl!,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => const SizedBox.shrink(),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(article.title, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (article.author != null)
                      Expanded(
                        child: Text(
                          'By ${article.author}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    if (article.publishedAt != null)
                      Text(
                        DateFormat.yMMMd().add_jm().format(
                              article.publishedAt!,
                            ),
                        style: theme.textTheme.bodySmall,
                      ),
                  ],
                ),
                const Divider(height: 32),
                Text(
                  article.description ?? 'No preview available.',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => _openUrl(context),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Read full story'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openUrl(BuildContext context) async {
    final uri = Uri.tryParse(article.url);
    if (uri == null || !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the article link.')),
        );
      }
    }
  }
}
