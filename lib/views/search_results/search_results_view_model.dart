import 'package:logger/logger.dart';
import 'package:set_jet/core/router_constants.dart';
import 'package:stacked/stacked.dart';
import 'package:set_jet/core/logger.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../core/locator.dart';

class SearchResultsViewModel extends BaseViewModel {
  Logger? log;

  final NavigationService? _navSrv = locator<NavigationService>();

  SearchResultsViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }
  goToDetails() {
    _navSrv!.navigateTo(charterDetailsViewRoute);
  }
}
