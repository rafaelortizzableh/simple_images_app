import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme.dart';

/// The provider for the [PreferredColorController].
final preferredColorControllerProvider =
    StateNotifierProvider<PreferredColorController, MaterialColor>(
  (ref) {
    final themeService = ref.watch(themeServiceProvider);
    return PreferredColorController(
      themeService,
    );
  },
);

class PreferredColorController extends StateNotifier<MaterialColor> {
  PreferredColorController(
    this._themeService,
  ) : super(_loadInitialValue(_themeService));

  static MaterialColor _loadInitialValue(ThemeService themeService) {
    final savedPreferredColorValue = themeService.getSavedPreferredColor();
    return savedPreferredColorValue;
  }

  final ThemeService _themeService;

  Future<void> updatePreferredColor(MaterialColor color) async {
    await _themeService.updatePreferredColor(color);
    state = color;
  }
}
