import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:set_jet/core/logger.dart';

class SearchViewModel extends BaseViewModel {
  Logger? log;

  var index = 0;

  SearchViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }

  onMultiLeg() {
    index = 2;
    notifyListeners();
  }

  ononRoundTrip() {
    index = 1;
    notifyListeners();
  }

  onOneWay() {
    index = 0;
    notifyListeners();
  }
}
