import 'package:flutter/material.dart';

import '../features/features.dart';
import 'core.dart';

Route<MaterialPageRoute> generatePageRoute(
  RouteSettings settings,
) {
  switch (settings.name) {
    case PhotosPage.routePath:
      return MaterialPageRoute(
        builder: (context) => const PhotosPage(),
        settings: settings,
      );
    case PhotoDetailPage.routePath:
      return MaterialPageRoute(
        builder: (context) {
          final args = settings.arguments;
          if (args is String) {
            return PhotoDetailPage(photoId: args);
          }
          return UnknownRouteScreen(settings: settings);
        },
      );
    case FavoritePhotosPage.routePath:
      return MaterialPageRoute(
        builder: (context) => const FavoritePhotosPage(),
        settings: settings,
      );
    case PhotoSearchPage.routePath:
      return MaterialPageRoute(
        builder: (context) => const PhotoSearchPage(),
        settings: settings,
      );
    case SearchHistoryPage.routePath:
      return MaterialPageRoute(
        builder: (context) => const SearchHistoryPage(),
        settings: settings,
      );
    case ThemePage.routePath:
      return MaterialPageRoute(
        builder: (context) => const ThemePage(),
        settings: settings,
      );

    default:
      return MaterialPageRoute(
        builder: (context) => UnknownRouteScreen(settings: settings),
        settings: settings,
      );
  }
}
