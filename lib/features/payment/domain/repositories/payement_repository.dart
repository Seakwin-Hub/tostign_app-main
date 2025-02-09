import 'dart:convert';

import 'package:get/get_connect/connect.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tostign/api/api_client.dart';
import 'package:tostign/features/payment/domain/models/offline_method_model.dart';
import 'package:tostign/features/payment/domain/repositories/payment_repository_interface.dart';
import 'package:tostign/util/app_constants.dart';

class PaymentRepository implements PaymentRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  PaymentRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(String? id) {
    throw UnimplementedError();
  }

  @override
  Future<List<OfflineMethodModel>?> getList(
      {int? offset, String? storeId}) async {
    List<OfflineMethodModel>? offlineMethodList;
    Response response =
        await apiClient.getData('${AppConstants.offlineMethodListUri}$storeId');
    if (response.statusCode == 200) {
      offlineMethodList = [];
      response.body.forEach((method) =>
          offlineMethodList!.add(OfflineMethodModel.fromJson(method)));
    }
    return offlineMethodList;
  }

  // Future<List<OfflineMethodModel>?> _getOfflineMethodList(String? storId) async {
  //   List<OfflineMethodModel>? offlineMethodList;
  //   Response response =
  //       await apiClient.getData('${AppConstants.offlineMethodListUri}$storId');
  //   if (response.statusCode == 200) {
  //     offlineMethodList = [];
  //     response.body.forEach((method) =>
  //         offlineMethodList!.add(OfflineMethodModel.fromJson(method)));
  //   }
  //   return offlineMethodList;
  // }

  @override
  Future<bool> saveOfflineInfo(String data, XFile? imgData) async {
    Map<String, String> dataDecode = Map<String, String>.from(jsonDecode(data));
    Response response = await apiClient.postMultipartData(
        AppConstants.offlinePaymentSaveInfoUri,
        dataDecode,
        [MultipartBody('receipt', imgData)]);
    return (response.statusCode == 200);
  }

  @override
  Future<bool> updateOfflineInfo(String data, XFile? imgData) async {
    Map<String, String> dataDecode = Map<String, String>.from(jsonDecode(data));
    Response response = await apiClient.postMultipartData(
        AppConstants.offlinePaymentUpdateInfoUri,
        dataDecode,
        [MultipartBody('receipt', imgData)]);
    return (response.statusCode == 200);
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }
}
