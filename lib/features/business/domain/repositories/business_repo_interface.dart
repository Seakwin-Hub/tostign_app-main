import 'package:get/get_connect/connect.dart';
import 'package:tostign/features/business/domain/models/business_plan_body.dart';
import 'package:tostign/interfaces/repository_interface.dart';

abstract class BusinessRepoInterface<T> implements RepositoryInterface<T> {
  Future<Response> setUpBusinessPlan(BusinessPlanBody businessPlanBody);
  Future<Response> subscriptionPayment(String id, String? paymentName);
}
