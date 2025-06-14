import 'package:get/get.dart';
import 'package:tostign/common/models/response_model.dart';
import 'package:tostign/features/profile/controllers/profile_controller.dart';
import 'package:tostign/features/verification/domein/services/verification_service_interface.dart';

class VerificationController extends GetxController implements GetxService {
  final VerificationServiceInterface verificationServiceInterface;

  VerificationController({required this.verificationServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _verificationCode = '';
  String get verificationCode => _verificationCode;

  void verifyTest() {
    _isLoading = true;
    update();
  }

  void updateVerificationCode(String query) {
    _verificationCode = query;
    update();
  }

  Future<ResponseModel> forgetPassword(String? email) async {
    _isLoading = true;
    update();
    ResponseModel responseModel =
        await verificationServiceInterface.forgetPassword(email);
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> resetPassword(String? resetToken, String number,
      String password, String confirmPassword) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await verificationServiceInterface
        .resetPassword(resetToken, number, password, confirmPassword);
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> verifyPhone(String? phone, String? token) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await verificationServiceInterface
        .verifyPhone(phone, _verificationCode, token);
    if (responseModel.isSuccess) {
      Get.find<ProfileController>().getUserInfo();
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> verifyToken(String? email) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await verificationServiceInterface
        .verifyToken(email, _verificationCode);
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> verifyFirebaseOtp(
      {required String phoneNumber,
      required String session,
      required String otp,
      required bool isSignUpPage,
      required String? token}) async {
    _isLoading = true;
    update();
    ResponseModel responseModel =
        await verificationServiceInterface.verifyFirebaseOtp(
            phoneNumber: phoneNumber,
            session: session,
            otp: otp,
            isSignUpPage: isSignUpPage,
            token: token);
    if (responseModel.isSuccess && isSignUpPage) {
      Get.find<ProfileController>().getUserInfo();
    }
    _isLoading = false;
    update();
    return responseModel;
  }
}
