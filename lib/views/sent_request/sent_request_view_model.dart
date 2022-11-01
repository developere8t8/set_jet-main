import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:set_jet/core/logger.dart';

class SentRequestViewModel extends BaseViewModel {
  Logger? log;

  SentRequestViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }
}
