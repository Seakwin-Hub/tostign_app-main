import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tostign/features/payment/domain/models/offline_method_model.dart';
import 'package:tostign/features/payment/domain/services/payment_service_interface.dart';
import 'package:tostign/helper/network_info.dart';

class PaymentController extends GetxController implements GetxService {
  final PaymentServiceInterface paymentServiceInterface;
  PaymentController({required this.paymentServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  XFile? _pickedFile;
  XFile? get pickedFile => _pickedFile;

  Uint8List? _rawFile;
  Uint8List? get rawFile => _rawFile;

  List<OfflineMethodModel>? _offlineMethodList;
  List<OfflineMethodModel>? get offlineMethodList => _offlineMethodList;

  List<TextEditingController> informationControllerList = [];
  List<FocusNode> informationFocusList = [];

  int _selectedOfflineBankIndex = 0;
  int get selectedOfflineBankIndex => _selectedOfflineBankIndex;

  Future<void> getOfflineMethodList(String? storeId) async {
    _offlineMethodList =
        await paymentServiceInterface.getOfflineMethodList(storeId);
    update();
  }

  void selectOfflineBank(int index, {bool canUpdate = true}) {
    _selectedOfflineBankIndex = index;
    if (canUpdate) {
      update();
    }
  }

  void pickImage() async {
    _pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_pickedFile != null) {
      _pickedFile = await NetworkInfo.compressImage(_pickedFile!);
      _rawFile = await _pickedFile!.readAsBytes();
    }
    update();
  }

  void initData({bool isUpdate = false}) {
    _pickedFile = null;
    _rawFile = null;
    _isLoading = false;
    if (isUpdate) {
      update();
    }
  }

  void changesMethod({bool canUpdate = true}) {
    List<MethodInformations>? methodInformation =
        offlineMethodList![selectedOfflineBankIndex].methodInformations!;

    informationControllerList = [];
    informationFocusList = [];

    for (int index = 0; index < methodInformation.length; index++) {
      informationControllerList.add(TextEditingController());
      informationFocusList.add(FocusNode());
    }
    if (canUpdate) {
      update();
    }
  }

  Future<bool> saveOfflineInfo(String data) async {
    _isLoading = true;
    update();
    bool success =
        await paymentServiceInterface.saveOfflineInfo(data, _pickedFile);
    _isLoading = false;
    update();
    return success;
  }

  Future<bool> updateOfflineInfo(String data) async {
    _isLoading = true;
    update();
    bool success =
        await paymentServiceInterface.updateOfflineInfo(data, _pickedFile);
    _isLoading = false;
    update();
    return success;
  }
}
