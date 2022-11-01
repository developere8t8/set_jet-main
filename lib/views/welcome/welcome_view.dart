import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'welcome_view_model.dart';

class WelcomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WelcomeViewModel>.reactive(
      builder: (BuildContext context, WelcomeViewModel viewModel, Widget? _) {
        return ThemeSwitchingArea(
          child: Builder(builder: (context) {
            var isLight = Theme.of(context).brightness == Brightness.light;

            return Scaffold(
              body: Center(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.all(95),
                          child: Image.asset(
                              'assets/logo_${!isLight ? 'dark' : 'light'}.png')),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
      viewModelBuilder: () => WelcomeViewModel(),
    );
  }
}
