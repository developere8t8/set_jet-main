import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:set_jet/core/logger.dart';

class FeedbackScreenViewModel extends BaseViewModel {
  Logger? log;

  FeedbackScreenViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }
}
