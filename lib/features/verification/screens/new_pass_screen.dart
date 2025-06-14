import 'package:tostign/features/profile/controllers/profile_controller.dart';
import 'package:tostign/features/profile/domain/models/userinfo_model.dart';
import 'package:tostign/features/auth/controllers/auth_controller.dart';
import 'package:tostign/features/auth/screens/sign_in_screen.dart';
import 'package:tostign/features/verification/controllers/verification_controller.dart';
import 'package:tostign/util/dimensions.dart';
import 'package:tostign/util/images.dart';
import 'package:tostign/util/styles.dart';
import 'package:tostign/common/widgets/custom_app_bar.dart';
import 'package:tostign/common/widgets/custom_button.dart';
import 'package:tostign/common/widgets/custom_snackbar.dart';
import 'package:tostign/common/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tostign/common/widgets/footer_view.dart';
import 'package:tostign/common/widgets/menu_drawer.dart';
import 'package:tostign/helper/responsive_helper.dart';
import 'package:tostign/helper/route_helper.dart';

class NewPassScreen extends StatefulWidget {
  final String? resetToken;
  final String? number;
  final bool fromPasswordChange;
  const NewPassScreen(
      {super.key,
      required this.resetToken,
      required this.number,
      required this.fromPasswordChange});

  @override
  State<NewPassScreen> createState() => _NewPassScreenState();
}

class _NewPassScreenState extends State<NewPassScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: CustomAppBar(
          title: widget.fromPasswordChange
              ? 'change_password'.tr
              : 'reset_password'.tr),
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
          margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
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
          child: Column(children: [
            Image.asset(Images.forgetIcon, width: 100),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),
            Text(
              'enter_new_password'.tr,
              textAlign: TextAlign.center,
              style: robotoRegular.copyWith(
                  color: Theme.of(context).hintColor,
                  fontSize: Dimensions.fontSizeDefault),
            ),
            const SizedBox(height: 50),
            Column(children: [
              CustomTextField(
                labelText: 'new_password'.tr,
                titleText: '8_character'.tr,
                controller: _newPasswordController,
                focusNode: _newPasswordFocus,
                nextFocus: _confirmPasswordFocus,
                inputType: TextInputType.visiblePassword,
                prefixImage: Images.lock,
                isPassword: true,
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),
              CustomTextField(
                labelText: 'confirm_password'.tr,
                titleText: '8_character'.tr,
                controller: _confirmPasswordController,
                focusNode: _confirmPasswordFocus,
                inputAction: TextInputAction.done,
                inputType: TextInputType.visiblePassword,
                prefixImage: Images.lock,
                isPassword: true,
                onSubmit: (text) => GetPlatform.isWeb ? _resetPassword() : null,
              ),
            ]),
            const SizedBox(height: 40),
            GetBuilder<VerificationController>(
                builder: (verificationController) {
              return GetBuilder<ProfileController>(
                  builder: (profileController) {
                return GetBuilder<AuthController>(builder: (authBuilder) {
                  return CustomButton(
                    buttonText: 'submit'.tr,
                    isLoading: (authBuilder.isLoading ||
                        profileController.isLoading ||
                        verificationController.isLoading),
                    onPressed: () => _resetPassword(),
                  );
                });
              });
            }),
          ]),
        )),
      ))),
    );
  }

  void _resetPassword() {
    String password = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    if (password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else if (password != confirmPassword) {
      showCustomSnackBar('confirm_password_does_not_matched'.tr);
    } else {
      if (widget.fromPasswordChange) {
        UserInfoModel user = Get.find<ProfileController>().userInfoModel!;
        user.password = password;
        Get.find<ProfileController>().changePassword(user).then((response) {
          if (response.isSuccess) {
            Get.back();
            showCustomSnackBar('password_updated_successfully'.tr,
                isError: false);
          } else {
            showCustomSnackBar(response.message);
          }
        });
      } else {
        Get.find<VerificationController>()
            .resetPassword(widget.resetToken, '+${widget.number!.trim()}',
                password, confirmPassword)
            .then((value) {
          if (value.isSuccess) {
            if (!mounted) return;
            if (!ResponsiveHelper.isDesktop(context)) {
              if (mounted) {
                Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
              }
            } else {
              if (mounted) {
                Get.offAllNamed(RouteHelper.getInitialRoute(fromSplash: false))
                    ?.then((value) {
                  Get.dialog(const SignInScreen(
                      exitFromApp: true, backFromThis: true));
                });
              }
            }
          } else {
            showCustomSnackBar(value.message);
          }
        });
      }
    }
  }
}
