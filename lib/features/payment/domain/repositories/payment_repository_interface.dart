import 'package:image_picker/image_picker.dart';
import 'package:tostign/features/payment/domain/models/offline_method_model.dart';
import 'package:tostign/interfaces/repository_interface.dart';

abstract class PaymentRepositoryInterface extends RepositoryInterface {
  @override
  Future<List<OfflineMethodModel>?> getList({int? offset, String? storeId});
  Future<bool> saveOfflineInfo(String data, XFile? imgData);
  Future<bool> updateOfflineInfo(String data, XFile? imgData);
}
