import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:set_jet/core/locator.dart';
import 'package:set_jet/core/router_constants.dart';
import 'package:set_jet/theme/dark.dart';
import 'package:set_jet/theme/light.dart';
import 'package:set_jet/views/home/home_view.dart';
import 'package:set_jet/views/post_login_screen/post_login_screen_view.dart';
import 'package:stacked/stacked.dart';
import 'package:set_jet/core/logger.dart';
import 'package:stacked_services/stacked_services.dart';

class WelcomeViewModel extends BaseViewModel {
  Logger? log;

  WelcomeViewModel() {
    this.log = getLogger(this.runtimeType.toString());

    Future.delayed(
      const Duration(
        seconds: 2,
      ),
      () {
        locator<NavigationService>().replaceWith(authViewRoute);
      },
    );
  }

  toggleTheme(context) {
    // var context = locator<NavigationService>().navigatorKey.currentContext;
    var theme = Theme.of(context).brightness;

    // var themeSwitcher = ThemeSwitcher.of(context);
    // print(themeSwitcher);

    ThemeSwitcher.of(context).changeTheme(theme: theme == Brightness.dark ? lightTheme : darkTheme);
  }
}
