import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:tostign/features/splash/controllers/splash_controller.dart';
import 'package:tostign/features/auth/controllers/auth_controller.dart';
import 'package:tostign/features/auth/domain/models/social_log_in_body.dart';
import 'package:tostign/helper/responsive_helper.dart';
import 'package:tostign/util/dimensions.dart';
import 'package:tostign/util/images.dart';
import 'package:tostign/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialLoginWidget extends StatelessWidget {
  const SocialLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    return Get.find<SplashController>().configModel != null &&
            Get.find<SplashController>().configModel!.socialLogin!.isNotEmpty &&
            (Get.find<SplashController>()
                    .configModel!
                    .socialLogin![0]
                    .status! ||
                Get.find<SplashController>()
                    .configModel!
                    .socialLogin![1]
                    .status!)
        ? Column(children: [
            Center(
                child: Text(
                    ResponsiveHelper.isDesktop(context)
                        ? 'or_continue_with'.tr
                        : 'social_login'.tr,
                    style: robotoMedium.copyWith(
                        color: ResponsiveHelper.isDesktop(context)
                            ? Theme.of(context).hintColor
                            : null))),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Get.find<SplashController>().configModel!.socialLogin![0].status!
                  ? InkWell(
                      onTap: () async {
                        GoogleSignInAccount googleAccount =
                            (await googleSignIn.signIn())!;
                        GoogleSignInAuthentication auth =
                            await googleAccount.authentication;
                        String? deviceToken =
                            await Get.find<AuthController>().saveDeviceToken();
                        Get.find<AuthController>()
                            .loginWithSocialMedia(SocialLogInBody(
                          email: googleAccount.email,
                          token: auth.accessToken,
                          uniqueId: googleAccount.id,
                          medium: 'google',
                          deviceToken: deviceToken,
                        ));
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: const EdgeInsets.all(
                            Dimensions.paddingSizeExtraSmall),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                spreadRadius: 1)
                          ],
                        ),
                        child: Image.asset(Images.google),
                      ),
                    )
                  : const SizedBox(),
              SizedBox(
                  width: Get.find<SplashController>()
                          .configModel!
                          .socialLogin![0]
                          .status!
                      ? Dimensions.paddingSizeSmall
                      : 0),
              // SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

              Get.find<SplashController>().configModel!.socialLogin![1].status!
                  ? InkWell(
                      onTap: () async {
                        LoginResult result = await FacebookAuth.instance
                            .login(loginBehavior: LoginBehavior.webOnly);
                        if (result.status == LoginStatus.success) {
                          Map userData =
                              await FacebookAuth.instance.getUserData();
                          String? deviceToken = await Get.find<AuthController>()
                              .saveDeviceToken();
                          Get.find<AuthController>()
                              .loginWithSocialMedia(SocialLogInBody(
                            email: userData['email'],
                            token: result.accessToken!.tokenString,
                            uniqueId: userData['id'],
                            medium: 'facebook',
                            deviceToken: deviceToken,
                          ));
                        }
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: const EdgeInsets.all(
                            Dimensions.paddingSizeExtraSmall),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                spreadRadius: 1)
                          ],
                        ),
                        child: Image.asset(Images.socialFacebook),
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Get.find<SplashController>()
                          .configModel!
                          .appleLogin!
                          .isNotEmpty &&
                      Get.find<SplashController>()
                          .configModel!
                          .appleLogin![0]
                          .status! &&
                      !GetPlatform.isAndroid &&
                      !GetPlatform.isWeb
                  ? InkWell(
                      onTap: () async {
                        final credential =
                            await SignInWithApple.getAppleIDCredential(
                          scopes: [
                            AppleIDAuthorizationScopes.email,
                            AppleIDAuthorizationScopes.fullName,
                          ],
                          webAuthenticationOptions: WebAuthenticationOptions(
                            clientId: Get.find<SplashController>()
                                .configModel!
                                .appleLogin![0]
                                .clientId!,
                            redirectUri: Uri.parse(
                                'https://tostign-web.6amtech.com/apple'),
                          ),
                        );
                        String? deviceToken =
                            await Get.find<AuthController>().saveDeviceToken();
                        Get.find<AuthController>()
                            .loginWithSocialMedia(SocialLogInBody(
                          email: credential.email,
                          token: credential.authorizationCode,
                          uniqueId: credential.authorizationCode,
                          medium: 'apple',
                          deviceToken: deviceToken,
                        ));
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: const EdgeInsets.all(
                            Dimensions.paddingSizeExtraSmall),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                spreadRadius: 1)
                          ],
                        ),
                        child: Image.asset(Images.appleLogo),
                      ),
                    )
                  : const SizedBox(),
            ]),
            const SizedBox(height: Dimensions.paddingSizeSmall),
          ])
        : const SizedBox();
  }
}
