import 'package:get/get.dart';

abstract class SocketAbstract extends GetxService {
  void connect();
  void disconnect();
  void listen();
  void send({required String event, required dynamic data});
}
