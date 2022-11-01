import 'package:logger/logger.dart';
import 'package:set_jet/core/router_constants.dart';
import 'package:stacked/stacked.dart';
import 'package:set_jet/core/logger.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../core/locator.dart';

class BookedChartersViewModel extends BaseViewModel {
  Logger? log;

  final NavigationService? _navService = locator<NavigationService>();

  BookedChartersViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }

  void back() {}

  void goToDetails() {
    _navService!.navigateTo(bookedCharterDetailViewRoute);
  }
}
