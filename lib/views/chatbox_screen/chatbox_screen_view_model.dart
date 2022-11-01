import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:set_jet/core/logger.dart';

class ChatboxScreenViewModel extends BaseViewModel {
  Logger? log;

  ChatboxScreenViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }
}
