import 'dart:async';

import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/core.dart';
import '../../features/features.dart';

class AppDependenciesLoader extends StatelessWidget {
  const AppDependenciesLoader({
    required this.dependenciesCompleter,
    super.key,
  });

  final Completer<InitialAppDependencies> dependenciesCompleter;

  static const _primaryColor = Colors.purple;
  static const _theme = CustomTheme(primaryColor: _primaryColor);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _theme.lightTheme(_primaryColor),
      darkTheme: _theme.darkTheme(_primaryColor),
      themeMode: ThemeMode.system,
      title: SimplePhotosApp.appTitle,
      home: FutureBuilder<InitialAppDependencies>(
        future: AppConfiguration.configureInitialDependencies(),
        builder: (context, snapshot) {
          return snapshot.when(
            data: (deps) {
              scheduleMicrotask(() => dependenciesCompleter.complete(deps));
              return const _AppLoadingWidget();
            },
            error: (error, _) => GenericError(
              onRetry: () {},
              errorText: error.toString(),
            ),
            loading: () => const _AppLoadingWidget(),
          );
        },
      ),
    );
  }
}

class _AppLoadingWidget extends StatelessWidget {
  const _AppLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppSpacingWidgets.verticalSpacing16,
            const Spacer(),
            Text(
              SimplePhotosApp.appTitle,
              style: context.textTheme.displaySmall?.copyWith(
                color: context.theme.primaryColor,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            const CircularProgressIndicator.adaptive(),
            AppSpacingWidgets.verticalSpacing16,
          ],
        ),
      ),
    );
  }
}
