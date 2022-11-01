import 'package:logger/logger.dart';
import 'package:set_jet/core/locator.dart';
import 'package:set_jet/core/router_constants.dart';
import 'package:stacked/stacked.dart';
import 'package:set_jet/core/logger.dart';
import 'package:stacked_services/stacked_services.dart';

class MessagesScreenViewModel extends BaseViewModel {
  Logger? log;
  final NavigationService? _navService = locator<NavigationService>();

    navigateToViewChatScreen() {
    _navService!.navigateTo(chatboxScreenViewRoute);
  }


  MessagesScreenViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }
}
