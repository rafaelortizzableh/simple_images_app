import 'package:shared_preferences/shared_preferences.dart';

abstract class AppConfiguration {
  /// Configures dependencies needed to run the application.
  ///
  /// [SharedPreferences], will be overriden
  /// on the [ProviderScope] of the app.
  static Future<InitialAppDependencies> configureInitialDependencies() async {
    final initialServices = await Future.wait([
      SharedPreferences.getInstance(),
    ]);

    final sharedPreferences = initialServices.first;

    return InitialAppDependencies(
      sharedPreferences: sharedPreferences,
    );
  }
}

class InitialAppDependencies {
  const InitialAppDependencies({
    required this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;
}
