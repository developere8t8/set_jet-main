import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:set_jet/core/locator.dart';
import 'package:set_jet/core/router_constants.dart';
import 'package:set_jet/views/time_zone_setting/time_zone_setting_view.dart';
import 'package:stacked/stacked.dart';
import 'package:set_jet/core/logger.dart';
import 'package:stacked_services/stacked_services.dart';

class PostLoginScreenViewModel extends BaseViewModel {
  Logger? log;
  final NavigationService? _navService = locator<NavigationService>();

  final currentPageNotifier = ValueNotifier<int>(0);
  final selector = ValueNotifier<bool>(false);

  final checkBoxValue = ValueNotifier<bool>(false);

  void ChangeCheckboxValue() {
    checkBoxValue.value = !checkBoxValue.value;
    notifyListeners();
  }

  void OptionSelector() {
    selector.value = !selector.value;
    notifyListeners();
  }

  void pageChange(index) {
    currentPageNotifier.value = index;
  }

  navigateToViewTimeZoneScreen() {
    _navService!.navigateTo(timeZoneSettingViewRoute);
  }

  PostLoginScreenViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }
}
