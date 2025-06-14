import 'dart:async';

import 'package:tostign/features/location/controllers/location_controller.dart';
import 'package:tostign/features/splash/controllers/splash_controller.dart';
import 'package:tostign/features/auth/controllers/auth_controller.dart';
import 'package:tostign/features/verification/controllers/verification_controller.dart';
import 'package:tostign/helper/route_helper.dart';
import 'package:tostign/util/dimensions.dart';
import 'package:tostign/util/styles.dart';
import 'package:tostign/common/widgets/custom_app_bar.dart';
import 'package:tostign/common/widgets/custom_button.dart';
import 'package:tostign/common/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tostign/common/widgets/footer_view.dart';
import 'package:tostign/common/widgets/menu_drawer.dart';

class VerificationScreen extends StatefulWidget {
  final String? number;
  final bool fromSignUp;
  final String? token;
  final String password;
  final String? firebaseSession;
  const VerificationScreen(
      {super.key,
      required this.number,
      required this.password,
      required this.fromSignUp,
      required this.token,
      this.firebaseSession});

  @override
  VerificationScreenState createState() => VerificationScreenState();
}

class VerificationScreenState extends State<VerificationScreen> {
  String? _number;
  Timer? _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();

    _number = widget.number!.startsWith('+')
        ? widget.number
        : '+${widget.number!.substring(1, widget.number!.length)}';
    _startTimer();
  }

  void _startTimer() {
    _seconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds = _seconds - 1;
      if (_seconds == 0) {
        timer.cancel();
        _timer?.cancel();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: CustomAppBar(title: 'otp_verification'.tr),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
          child: Center(
              child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: FooterView(
            child: Container(
          width: context.width > 700 ? 700 : context.width,
          padding: context.width > 700
              ? const EdgeInsets.all(Dimensions.paddingSizeDefault)
              : null,
          margin: context.width > 700
              ? const EdgeInsets.all(Dimensions.paddingSizeDefault)
              : null,
          decoration: context.width > 700
              ? BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 5, spreadRadius: 1)
                  ],
                )
              : null,
          child: GetBuilder<VerificationController>(
              builder: (verificationController) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Get.find<SplashController>().configModel!.demo!
                      ? Text(
                          'for_demo_purpose'.tr,
                          style: robotoRegular,
                        )
                      : RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'enter_the_verification_sent_to'.tr,
                                style: robotoRegular.copyWith(
                                    color: Theme.of(context).disabledColor)),
                            TextSpan(
                                text: ' $_number',
                                style: robotoMedium.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color)),
                          ]),
                          textAlign: TextAlign.center),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: context.width > 850
                            ? 50
                            : Dimensions.paddingSizeDefault,
                        vertical: 35),
                    child: PinCodeTextField(
                      length: 6,
                      appContext: context,
                      keyboardType: TextInputType.number,
                      animationType: AnimationType.slide,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        fieldHeight: 60,
                        fieldWidth: 50,
                        borderWidth: 1,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusSmall),
                        selectedColor: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.2),
                        selectedFillColor: Colors.white,
                        inactiveFillColor: Theme.of(context)
                            .disabledColor
                            .withValues(alpha: 0.2),
                        inactiveColor: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.2),
                        activeColor: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.4),
                        activeFillColor: Theme.of(context)
                            .disabledColor
                            .withValues(alpha: 0.2),
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      onChanged: verificationController.updateVerificationCode,
                      beforeTextPaste: (text) => true,
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      'did_not_receive_the_code'.tr,
                      style: robotoRegular.copyWith(
                          color: Theme.of(context).disabledColor),
                    ),
                    GetBuilder<VerificationController>(
                        builder: (verificationController) {
                      return GetBuilder<AuthController>(
                          builder: (authController) {
                        return !authController.isLoading ||
                                !verificationController.isLoading
                            ? TextButton(
                                onPressed: _seconds < 1
                                    ? () async {
                                        ///Firebase OTP
                                        if (widget.firebaseSession != null) {
                                          await authController
                                              .firebaseVerifyPhoneNumber(
                                                  _number!, widget.token,
                                                  fromSignUp: widget.fromSignUp,
                                                  canRoute: false);
                                          _startTimer();
                                        } else {
                                          _resendOtp(verificationController);
                                        }
                                      }
                                    : null,
                                child: Text(
                                    '${'resend'.tr}${_seconds > 0 ? ' ($_seconds)' : ''}'),
                              )
                            : Container(
                                height: 20,
                                width: 20,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeLarge),
                                child: const CircularProgressIndicator(),
                              );
                      });
                    }),
                  ]),
                  verificationController.verificationCode.length == 6
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeLarge),
                          child: CustomButton(
                            buttonText: 'verify'.tr,
                            isLoading: verificationController.isLoading,
                            onPressed: () {
                              if (widget.firebaseSession != null) {
                                verificationController
                                    .verifyFirebaseOtp(
                                  phoneNumber: _number!,
                                  session: widget.firebaseSession!,
                                  otp: verificationController.verificationCode,
                                  isSignUpPage: widget.fromSignUp,
                                  token: widget.token,
                                )
                                    .then((value) {
                                  if (value.isSuccess) {
                                    showCustomSnackBar(
                                        'successfully_verified'.tr,
                                        isError: false);
                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      if (widget.fromSignUp) {
                                        Get.find<LocationController>()
                                            .navigateToLocationScreen(
                                                'verification',
                                                offAll: true);
                                      } else {
                                        Get.toNamed(
                                            RouteHelper.getResetPasswordRoute(
                                                _number,
                                                verificationController
                                                    .verificationCode,
                                                'reset-password'));
                                      }
                                    });
                                  } else {
                                    showCustomSnackBar(value.message);
                                  }
                                });
                              } else {
                                _verifyOtp(verificationController);
                              }
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                ]);
          }),
        )),
      ))),
    );
  }

  void _resendOtp(VerificationController verificationController) {
    if (widget.fromSignUp) {
      Get.find<AuthController>().login(_number, widget.password).then((value) {
        if (value.isSuccess) {
          _startTimer();
          showCustomSnackBar('resend_code_successful'.tr, isError: false);
        } else {
          showCustomSnackBar(value.message);
        }
      });
    } else {
      verificationController.forgetPassword(_number).then((value) {
        if (value.isSuccess) {
          _startTimer();
          showCustomSnackBar('resend_code_successful'.tr, isError: false);
        } else {
          showCustomSnackBar(value.message);
        }
      });
    }
  }

  void _verifyOtp(VerificationController verificationController) {
    if (widget.fromSignUp) {
      verificationController.verifyPhone(_number, widget.token).then((value) {
        if (value.isSuccess) {
          showCustomSnackBar('successfully_verified'.tr, isError: false);
          Future.delayed(const Duration(seconds: 1), () {
            Get.find<LocationController>()
                .navigateToLocationScreen('verification', offAll: true);
          });
        } else {
          showCustomSnackBar(value.message);
        }
      });
    } else {
      verificationController.verifyToken(_number).then((value) {
        if (value.isSuccess) {
          Get.toNamed(RouteHelper.getResetPasswordRoute(_number,
              verificationController.verificationCode, 'reset-password'));
        } else {
          showCustomSnackBar(value.message);
        }
      });
    }
  }
}
