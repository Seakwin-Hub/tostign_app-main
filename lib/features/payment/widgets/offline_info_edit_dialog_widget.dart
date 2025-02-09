import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tostign/features/order/domain/models/order_model.dart';
import 'package:tostign/features/payment/controllers/payment_controller.dart';
import 'package:tostign/features/payment/widgets/offline_image_pick_widget.dart';
import 'package:tostign/util/dimensions.dart';
import 'package:tostign/util/images.dart';
import 'package:tostign/util/styles.dart';
import 'package:tostign/common/widgets/custom_button.dart';
import 'package:tostign/common/widgets/custom_snackbar.dart';
// import 'package:tostign/common/widgets/custom_text_field.dart';

class OfflineInfoEditDialogWidget extends StatefulWidget {
  final OfflinePayment offlinePayment;
  final int orderId;
  const OfflineInfoEditDialogWidget(
      {super.key, required this.offlinePayment, required this.orderId});

  @override
  State<OfflineInfoEditDialogWidget> createState() =>
      _OfflineInfoEditDialogWidgetState();
}

class _OfflineInfoEditDialogWidgetState
    extends State<OfflineInfoEditDialogWidget> {
  @override
  void initState() {
    super.initState();
    Get.find<PaymentController>().initData();
    // Get.find<PaymentController>().informationControllerList = [];
    // Get.find<PaymentController>().informationFocusList = [];
    // for (int i = 0; i < widget.offlinePayment.input!.length; i++) {
    //   Get.find<PaymentController>().informationControllerList.add(
    //       TextEditingController(text: widget.offlinePayment.input![i].receipt));
    //   Get.find<PaymentController>().informationFocusList.add(FocusNode());
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: GetBuilder<PaymentController>(builder: (paymentController) {
            return SingleChildScrollView(
              child: Column(children: [
                Image.asset(Images.offlinePayment, height: 100),
                const SizedBox(height: Dimensions.paddingSizeDefault),
                Text('update_payment_info'.tr,
                    textAlign: TextAlign.center,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    )),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                OfflineImagePickWidget(
                  paymentController: paymentController,
                  radius: Dimensions.radiusLarge,
                  width: MediaQuery.of(context).size.width,
                  margin: 2,
                  height: 200,
                ),
                // ListView.builder(
                //   itemCount: widget.offlinePayment.input!.length,
                //   shrinkWrap: true,
                //   physics: const NeverScrollableScrollPhysics(),
                //   padding: const EdgeInsets.symmetric(
                //       vertical: Dimensions.paddingSizeSmall),
                //   itemBuilder: (context, i) {
                //     return Container(
                //       decoration: BoxDecoration(
                //           color: Theme.of(context).cardColor,
                //           borderRadius:
                //               BorderRadius.circular(Dimensions.radiusLarge),
                //           boxShadow: const [
                //             BoxShadow(
                //                 color: Colors.black12,
                //                 blurRadius: 5,
                //                 spreadRadius: 1)
                //           ]),
                //       padding: const EdgeInsets.all(5),
                //       child: Center(
                //         child: InkWell(
                //           onTap: () => paymentController.pickImage(),
                //           child: paymentController.rawFile != null
                //               ? ClipRRect(
                //                   borderRadius: BorderRadius.circular(
                //                       Dimensions.radiusLarge),
                //                   child: Image.memory(
                //                     paymentController.rawFile!,
                //                     width: 340,
                //                     height: 150,
                //                     fit: BoxFit.fill,
                //                   ),
                //                 )
                //               : Padding(
                //                   padding: const EdgeInsets.symmetric(
                //                       vertical:
                //                           Dimensions.paddingSizeLarge + 30),
                //                   child: Image(
                //                     image: AssetImage(Images.cameraImg),
                //                     color: Theme.of(context)
                //                         .primaryColor
                //                         .withValues(alpha: 0.3),
                //                     width: 45,
                //                     fit: BoxFit.cover,
                //                   ),
                //                 ),
                //         ),
                //       ),
                //     );
                //   },
                // ),
                SizedBox(
                  height: Dimensions.paddingSizeExtraLarge,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // const Spacer(),
                      CustomButton(
                        width: 150,
                        color: Theme.of(context)
                            .disabledColor
                            .withValues(alpha: 0.5),
                        textColor:
                            Theme.of(context).textTheme.bodyMedium!.color,
                        buttonText: 'cancel'.tr,
                        onPressed: () => Get.back(),
                      ),
                      CustomButton(
                          width: 150,
                          buttonText: 'update'.tr,
                          isLoading: paymentController.isLoading,
                          onPressed: () {
                            // for (int i = 0;
                            //     i <
                            //         paymentController
                            //             .informationControllerList.length;
                            //     i++) {
                            //   if (paymentController
                            //       .informationControllerList[i].text.isEmpty) {
                            //     showCustomSnackBar(
                            //         'please_provide_every_information'.tr);
                            //     break;
                            //   } else {
                            if (widget.orderId.toString().isNotEmpty) {
                              Map<String, String> data = {
                                "_method": "post",
                                "order_id": widget.orderId.toString(),
                                "method_id": widget
                                    .offlinePayment.data!.methodId
                                    .toString(),
                              };
                              paymentController
                                  .updateOfflineInfo(jsonEncode(data))
                                  .then((success) {
                                if (success) {
                                  Get.back();
                                } else {
                                  showCustomSnackBar("Invalid Order try again");
                                }
                              });
                            }

                            // for (int i = 0;
                            //     i <
                            //         paymentController
                            //             .informationControllerList.length;
                            //     i++) {
                            //   data.addAll({
                            //     widget.offlinePayment.input![i].referrence!.userData
                            //             .toString():
                            //         paymentController
                            //             .informationControllerList[i].text,
                            //   });
                            // }
                          }
                          // }
                          // },
                          ),
                    ])
              ]),
            );
          }),
        ),
      ),
    );
  }
}
