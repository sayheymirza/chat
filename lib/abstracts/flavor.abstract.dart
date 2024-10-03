import 'package:chat/models/event.model.dart';

abstract class FlavorAbstract {
  void listen();
  void feedback();
  void showAppInStore();
  void update();
  Future<EventParchaseResultModel> purchase(EventParchaseParamsModel params);
}
