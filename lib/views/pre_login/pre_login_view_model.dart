import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:set_jet/core/locator.dart';
import 'package:set_jet/views/login_screen/login_screen_view.dart';
import 'package:set_jet/views/post_login_screen/post_login_screen_view.dart';
import 'package:stacked/stacked.dart';
import 'package:set_jet/core/logger.dart';
import 'package:stacked_services/stacked_services.dart';

class PreLoginViewModel extends BaseViewModel {
  Logger? log;
  final NavigationService? _navService = locator<NavigationService>();

  final currentPageNotifier = ValueNotifier<int>(0);

  bool expanded = false;

  int defaultLines = 6;

  toggleReadMore() {
    expanded = !expanded;
    notifyListeners();
  }

  navigateToViewLoginScreen() {
    _navService!.navigateToView(LoginScreenView());
  }

  navigateToViewHomePostLoginScreen() {
    _navService!.navigateToView(PostLoginScreenView());
  }

  void pageChange(index) {
    currentPageNotifier.value = index;
  }

  PreLoginViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }
}
