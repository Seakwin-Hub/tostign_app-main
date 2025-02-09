import 'package:tostign/features/payment/domain/models/offline_method_model.dart';
import 'package:image_picker/image_picker.dart';

abstract class PaymentServiceInterface {
  Future<List<OfflineMethodModel>?> getOfflineMethodList(String? storeId);
  Future<bool> saveOfflineInfo(String data, XFile? imgData);
  Future<bool> updateOfflineInfo(String data, XFile? imgData);
}
