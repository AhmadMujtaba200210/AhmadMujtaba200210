# 📰 News Opportunities

A cross-platform **Flutter** mobile app that brings together the latest news and
curated **opportunities** — jobs, scholarships, internships, and events — in a
single, fast, bookmarkable feed.

## ✨ Features

- **Category feed** — browse Top Stories, Jobs, Scholarships, Internships,
  Events, Technology, and Business.
- **Article detail view** — read a preview and open the full story in the
  browser.
- **Bookmarks** — save articles for later; persisted on-device with
  `shared_preferences`.
- **Pull-to-refresh** and graceful error / empty states.
- **Light & dark themes** following the system setting (Material 3).
- **Works offline out of the box** — ships with sample data so you can explore
  the UI without an API key.

## 🏗️ Architecture

```
lib/
├── main.dart                  # App entry point + MaterialApp setup
├── models/
│   └── article.dart           # Article model + ArticleCategory enum
├── services/
│   ├── news_service.dart      # NewsAPI client (+ offline sample data)
│   ├── bookmark_store.dart    # Local persistence of saved articles
│   └── news_provider.dart     # ChangeNotifier app state
├── screens/
│   ├── home_screen.dart       # Bottom-nav shell
│   ├── feed_screen.dart       # Category feed
│   ├── saved_screen.dart      # Bookmarked articles
│   └── article_detail_screen.dart
├── widgets/
│   └── article_card.dart      # Reusable article card
└── theme/
    └── app_theme.dart         # Light & dark Material 3 themes
```

State management uses [`provider`](https://pub.dev/packages/provider) with a
single `NewsProvider` `ChangeNotifier`.

## 🚀 Getting started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.10 or newer.

### Install & run

```bash
cd news_opportunities_app
flutter pub get
flutter run
```

The app launches with bundled sample articles. To load **live** news, get a
free API key from [newsapi.org](https://newsapi.org) and pass it at runtime:

```bash
flutter run --dart-define=NEWS_API_KEY=your_api_key_here
```

### Tests

```bash
flutter test
```

## ⚙️ Configuration

| Define          | Description                          | Default |
| --------------- | ------------------------------------ | ------- |
| `NEWS_API_KEY`  | NewsAPI key for live headlines       | _empty_ (sample data) |

## 🗺️ Roadmap

- [ ] Full-text in-app reader (WebView)
- [ ] Push notifications for new opportunities
- [ ] Keyword search & saved searches
- [ ] User accounts and cross-device sync

## 📄 License

Released under the MIT License.
