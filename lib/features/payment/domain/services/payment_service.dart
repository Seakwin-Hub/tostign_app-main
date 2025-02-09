import 'package:image_picker/image_picker.dart';
import 'package:tostign/features/payment/domain/models/offline_method_model.dart';
import 'package:tostign/features/payment/domain/repositories/payment_repository_interface.dart';
import 'package:tostign/features/payment/domain/services/payment_service_interface.dart';

class PaymentService implements PaymentServiceInterface {
  final PaymentRepositoryInterface paymentRepositoryInterface;
  PaymentService({required this.paymentRepositoryInterface});

  @override
  Future<List<OfflineMethodModel>?> getOfflineMethodList(
      String? storeId) async {
    return await paymentRepositoryInterface.getList(storeId: storeId);
  }

  @override
  Future<bool> saveOfflineInfo(String data, XFile? imgData) async {
    return await paymentRepositoryInterface.saveOfflineInfo(data, imgData);
  }

  @override
  Future<bool> updateOfflineInfo(String data, XFile? imgData) async {
    return await paymentRepositoryInterface.updateOfflineInfo(data, imgData);
  }
}
