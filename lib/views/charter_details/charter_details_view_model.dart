import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:set_jet/core/logger.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../core/locator.dart';

class CharterDetailsViewModel extends BaseViewModel {
  Logger? log;

  final NavigationService? _navSrv = locator<NavigationService>();

  CharterDetailsViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }

  back() {
    _navSrv!.back();
  }
}
