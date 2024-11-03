import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app.dart';
import '../../features/features.dart';
import '../core.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = context.textTheme;
    final isLightTheme = context.theme.brightness == Brightness.light;

    return Drawer(
      child: StatusBarWrapper(
        statusBarStyle:
            isLightTheme ? StatusBarStyle.dark : StatusBarStyle.light,
        child: SafeArea(
          child: Padding(
            padding: AppConstants.padding24,
            child: Column(
              children: [
                ListTile(
                  tileColor: context.theme.primaryColor,
                  title: Text(
                    SimplePhotosApp.appTitle,
                    style: textTheme.titleLarge?.copyWith(
                      color: context.theme.foregroundColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppConstants.borderRadius16,
                  ),
                  splashColor: context.theme.primaryColor.withOpacity(0.25),
                  onTap: () {
                    HapticFeedback.mediumImpact().ignore();
                  },
                ),
                const Spacer(),
                ListTile(
                  leading: Icon(
                    isLightTheme ? Icons.sunny : Icons.nightlight_round,
                  ),
                  title: const Text('Change Theme'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed(ThemePage.routePath);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('About'),
                  onTap: () {
                    Navigator.pop(context);
                    showAboutDialog(
                      context: context,
                      applicationName: SimplePhotosApp.appTitle,
                      children: [
                        const Text(
                          'This app is a simple Flutter app that uses the Unsplash API to display photos.',
                        ),
                        AppSpacingWidgets.verticalSpacing8,
                        const Text(
                          'Made with ❤️ by ${AppConstants.authorName}',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: const Text('View Licenses'),
                  onTap: () {
                    Navigator.pop(context);
                    showLicensePage(
                      context: context,
                      applicationName: SimplePhotosApp.appTitle,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Exit'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
