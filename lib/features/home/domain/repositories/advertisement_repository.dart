import 'package:get/get.dart';
import 'package:tostign/api/api_client.dart';
import 'package:tostign/features/home/domain/models/advertisement_model.dart';
import 'package:tostign/features/home/domain/repositories/advertisement_repository_interface.dart';
import 'package:tostign/util/app_constants.dart';

class AdvertisementRepository implements AdvertisementRepositoryInterface {
  final ApiClient apiClient;
  AdvertisementRepository({required this.apiClient});

  @override
  Future<List<AdvertisementModel>?> getList({int? offset}) async {
    List<AdvertisementModel>? advertisementList;
    Response response =
        await apiClient.getData(AppConstants.advertisementListUri);
    if (response.statusCode == 200) {
      advertisementList = [];
      response.body.forEach((data) {
        advertisementList?.add(AdvertisementModel.fromJson(data));
      });
    }
    return advertisementList;
  }

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
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }
}
