import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:set_jet/core/logger.dart';

class BookedCharterDetailViewModel extends BaseViewModel {
  Logger? log;

  BookedCharterDetailViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }
}
