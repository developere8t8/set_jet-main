import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:set_jet/core/locator.dart';
import 'package:set_jet/core/router_constants.dart';
import 'package:stacked/stacked.dart';
import 'package:set_jet/core/logger.dart';
import 'package:stacked_services/stacked_services.dart';

class TimeZoneSettingViewModel extends BaseViewModel {
  Logger? log;
  final NavigationService? _navService = locator<NavigationService>();
  final toggleIndex = ValueNotifier<int>(0);

  void timeZoneIndex(index) {
    toggleIndex.value = index;
    notifyListeners();
  }

  navigateToSubsciptionScreen() {
    _navService!.navigateTo(homeViewRoute);
  }

  TimeZoneSettingViewModel() {
    log = getLogger(runtimeType.toString());
  }
}
