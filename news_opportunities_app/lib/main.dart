import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'services/news_provider.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const NewsOpportunitiesApp());
}

class NewsOpportunitiesApp extends StatelessWidget {
  const NewsOpportunitiesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewsProvider()..init(),
      child: MaterialApp(
        title: 'News Opportunities',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
