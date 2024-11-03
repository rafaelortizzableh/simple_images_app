import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final depsCompleter = Completer<InitialAppDependencies>();

  runApp(
    AppDependenciesLoader(
      dependenciesCompleter: depsCompleter,
    ),
  );

  final dependencies = await depsCompleter.future;

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesServiceProvider.overrideWithValue(
          SharedPreferencesService(
            dependencies.sharedPreferences,
          ),
        )
      ],
      child: const SimplePhotosApp(),
    ),
  );
}
