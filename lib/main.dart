import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:set_jet/provider/loginprovider.dart';
import 'package:set_jet/theme/dark.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:get_storage/get_storage.dart';
import 'core/locator.dart';
import 'core/router_constants.dart';
import 'core/router.dart' as router;
import 'theme/light.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocatorInjector.setUpLocator();
  await GetStorage.init();
  GetStorage().writeIfNull("user-theme", "dark");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDark = GetStorage().read<String>("user-theme") == "dark";
    //initialize screenutil
    return WillPopScope(
        onWillPop: () async => false,
        child: ThemeProvider(
          initTheme: isDark ? darkTheme : lightTheme,
          builder: (_, theme) {
            return ScreenUtilInit(
              designSize: const Size(390, 844),
              splitScreenMode: true,
              builder: (BuildContext context, child) {
                return ChangeNotifierProvider(
                  create: (context) => LoginMethods(),
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: theme,
                    // ignore: deprecated_member_use
                    navigatorKey: locator<NavigationService>().navigatorKey,
                    onGenerateRoute: router.Router.generateRoute,
                    initialRoute: welcomeViewRoute,
                  ),
                );
              },
            );
          },
        ));
  }
}
