import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tostign/common/models/response_model.dart';
import 'package:tostign/api/api_client.dart';
import 'package:tostign/features/auth/controllers/auth_controller.dart';
import 'package:tostign/features/verification/domein/reposotories/verification_repository_interface.dart';
import 'package:tostign/util/app_constants.dart';

class VerificationRepository implements VerificationRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  VerificationRepository(
      {required this.sharedPreferences, required this.apiClient});

  @override
  Future<ResponseModel> forgetPassword(String? phone) async {
    String? deviceToken = await Get.find<AuthController>().saveDeviceToken();
    Response response = await apiClient.postData(AppConstants.forgetPasswordUri,
        {"phone": phone, "cm_firebase_token": deviceToken!},
        handleError: false);
    if (response.statusCode == 200) {
      return ResponseModel(true, response.body["message"]);
    } else {
      return ResponseModel(false, response.statusText);
    }
  }

  @override
  Future<ResponseModel> resetPassword(String? resetToken, String number,
      String password, String confirmPassword) async {
    Response response = await apiClient.postData(
      AppConstants.resetPasswordUri,
      {
        "_method": "put",
        "reset_token": resetToken,
        "phone": number,
        "password": password,
        "confirm_password": confirmPassword
      },
      handleError: false,
    );
    if (response.statusCode == 200) {
      return ResponseModel(true, response.body["message"]);
    } else {
      return ResponseModel(false, response.statusText);
    }
  }

  @override
  Future<ResponseModel> verifyPhone(String? phone, String otp) async {
    Response response = await apiClient
        .postData(AppConstants.verifyPhoneUri, {"phone": phone, "otp": otp});
    if (response.statusCode == 200) {
      return ResponseModel(true, response.body["message"]);
    } else {
      return ResponseModel(false, response.statusText);
    }
  }

  @override
  Future<ResponseModel> verifyFirebaseOtp(
      {required String phoneNumber,
      required String session,
      required String otp,
      required bool isSignUpPage}) async {
    Response response = await apiClient.postData(
      AppConstants.firebaseAuthVerify,
      {
        'sessionInfo': session,
        'phoneNumber': phoneNumber,
        'code': otp,
        'is_reset_token': isSignUpPage ? 0 : 1,
      },
    );
    if (response.statusCode == 200) {
      return ResponseModel(true, response.body["message"]);
    } else {
      return ResponseModel(false, response.statusText);
    }
  }

  @override
  Future<ResponseModel> verifyToken(String? phone, String token) async {
    Response response = await apiClient.postData(
        AppConstants.verifyTokenUri, {"phone": phone, "reset_token": token});
    if (response.statusCode == 200) {
      return ResponseModel(true, response.body["message"]);
    } else {
      return ResponseModel(false, response.statusText);
    }
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
  Future getList({int? offset}) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }
}
