import 'package:chat/models/event.model.dart';

abstract class FlavorAbstract {
  void listen();
  void feedback();
  void showAppInStore();
  void update();
  void purchase(
    EventParchaseParamsModel params,
    Function(EventParchaseResultModel result) callback,
  );
}
