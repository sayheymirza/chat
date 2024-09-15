import 'package:chat/models/plan.model.dart';

class ApiDataHandshakeResponseModel {
  Map<String, dynamic> configs;
  List<PlanModel> plans;

  ApiDataHandshakeResponseModel({
    required this.configs,
    required this.plans,
  });
}
