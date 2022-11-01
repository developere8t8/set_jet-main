import 'package:logger/logger.dart';
import 'package:set_jet/core/locator.dart';
import 'package:set_jet/views/home/home_view.dart';
import 'package:set_jet/views/post_login_screen/post_login_screen_view.dart';
import 'package:stacked/stacked.dart';
import 'package:set_jet/core/logger.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../core/router_constants.dart';

class LoginScreenViewModel extends BaseViewModel {
  Logger? log;
  final NavigationService? _navService = locator<NavigationService>();

  navigateToViewHomeScreen() {
    _navService!.navigateTo(homeViewRoute);
  }

  LoginScreenViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }
}
