import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/news_provider.dart';
import '../widgets/article_card.dart';
import 'article_detail_screen.dart';

/// Lists the articles the user has bookmarked.
class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, provider, _) {
        if (provider.saved.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bookmarks_outlined, size: 48),
                  SizedBox(height: 16),
                  Text(
                    'Bookmarked articles will appear here.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: provider.saved.length,
          itemBuilder: (context, index) {
            final article = provider.saved[index];
            return ArticleCard(
              article: article,
              saved: true,
              onToggleSaved: () => provider.toggleSaved(article),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ArticleDetailScreen(article: article),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
