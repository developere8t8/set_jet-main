import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:set_jet/theme/dark.dart';
import 'package:set_jet/theme/light.dart';

class ThemeService {
  static void toggle(context) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    final theme = !isLight ? darkTheme : lightTheme;
    // print(theme);
    ThemeSwitcher.of(context).changeTheme(theme: theme);
  }
}
