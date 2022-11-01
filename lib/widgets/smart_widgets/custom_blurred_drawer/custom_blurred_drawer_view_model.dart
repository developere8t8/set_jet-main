import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:set_jet/core/router_constants.dart';

import 'package:stacked/stacked.dart';
import 'package:set_jet/core/logger.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../constants/drawer_enum.dart';
import '../../../core/locator.dart';

class CustomBlurredDrawerViewModel extends BaseViewModel {
  Logger? log;

  final drawerOption;

  final NavigationService? _navService = locator<NavigationService>();

  CustomBlurredDrawerViewModel(this.drawerOption) {
    // drawerOption = ModalRoute.of(context).settings.arguments;

    this.log = getLogger(this.runtimeType.toString());
  }

  navigateSettings() {
    if (drawerOption != DrawerOptions.Settings)
      _navService!.navigateTo(userSettingScreebViewRoute);
  }

  navigateBookCharters() {
    if (drawerOption != DrawerOptions.BookedCharters)
      _navService!.navigateTo(bookedCharterViewRoute);
  }

  navigateSentRequests() {
    if (drawerOption != DrawerOptions.SentRequests)
      _navService!.navigateTo(sentRequestViewRoute);
  }

  navigateSearchFlights() {
    if (drawerOption != DrawerOptions.SearchFlights)
      _navService!.navigateTo(searchViewRoute);
  }

  navigateHome() {
    if (drawerOption != DrawerOptions.Home)
      _navService!.navigateTo(homeViewRoute);
  }
}
