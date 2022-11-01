import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../theme/common.dart';
import '../../theme/dark.dart';
import '../../theme/light.dart';

class CustomThemeSwitch extends StatelessWidget {
  const CustomThemeSwitch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var isLight = theme.brightness == Brightness.light;
    return ThemeSwitcher(builder: (context) {
      return Container(
          margin: const EdgeInsets.only(
            right: 16,
            left: 16,
            top: 10,
            bottom: 5,
          ),
          width: 73,
          decoration: BoxDecoration(
            color: isLight ? const Color(0x1a000000) : const Color(0x1AFFFFFF),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: IconButton(
                    color: !isLight ? Colors.grey : accentColor,
                    icon: Icon(
                      Icons.wb_sunny,
                    ),
                    onPressed: () {
                      ThemeSwitcher.of(context).changeTheme(theme: lightTheme);
                      GetStorage().write("user-theme", "light");
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    color: isLight ? Colors.grey : accentColor,
                    icon: const Icon(
                      Icons.mode_night,
                    ),
                    onPressed: () {
                      ThemeSwitcher.of(context).changeTheme(theme: darkTheme);
                      GetStorage().write("user-theme", "dark");
                    },
                  ),
                ),
              ],
            ),
          ));
    });
  }
}
