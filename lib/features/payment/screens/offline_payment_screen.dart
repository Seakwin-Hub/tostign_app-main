import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tostign/common/widgets/transaction_error_widget.dart';
import 'package:tostign/features/checkout/controllers/checkout_controller.dart';
import 'package:tostign/features/checkout/domain/models/place_order_body_model.dart';
import 'package:tostign/features/parcel/controllers/parcel_controller.dart';
import 'package:tostign/features/payment/controllers/payment_controller.dart';
import 'package:tostign/features/payment/domain/models/offline_method_model.dart';
import 'package:tostign/features/payment/widgets/offline_image_pick_widget.dart';
import 'package:tostign/features/payment/widgets/scan_qr_bottom_sheet.dart';
import 'package:tostign/helper/price_converter.dart';
import 'package:tostign/helper/responsive_helper.dart';
import 'package:tostign/helper/route_helper.dart';
import 'package:tostign/util/dimensions.dart';
import 'package:tostign/util/images.dart';
import 'package:tostign/util/styles.dart';
import 'package:tostign/common/widgets/custom_app_bar.dart';
import 'package:tostign/common/widgets/custom_button.dart';
import 'package:tostign/common/widgets/custom_snackbar.dart';
// import 'package:tostign/common/widgets/custom_text_field.dart';
import 'package:tostign/common/widgets/footer_view.dart';

class OfflinePaymentScreen extends StatefulWidget {
  final PlaceOrderBodyModel placeOrderBody;
  final int zoneId;
  final double total;
  final double? maxCodOrderAmount;
  final bool fromCart;
  final bool isCashOnDeliveryActive;
  final bool forParcel;
  final int? storeId;

  const OfflinePaymentScreen(
      {super.key,
      required this.placeOrderBody,
      required this.zoneId,
      required this.total,
      required this.maxCodOrderAmount,
      required this.fromCart,
      required this.isCashOnDeliveryActive,
      this.storeId,
      required this.forParcel});

  @override
  State<OfflinePaymentScreen> createState() => _OfflinePaymentScreenState();
}

class _OfflinePaymentScreenState extends State<OfflinePaymentScreen> {
  PageController pageController = PageController(
      viewportFraction: 0.85,
      initialPage: Get.find<PaymentController>().selectedOfflineBankIndex);
  // final TextEditingController _customerNoteController = TextEditingController();
  // final FocusNode _customerNoteNode = FocusNode();

  @override
  void initState() {
    super.initState();

    initCall();
  }

  Future<void> initCall() async {
    if (widget.forParcel) {
      pageController = PageController(
          viewportFraction: 0.85,
          initialPage: Get.find<ParcelController>().selectedOfflineBankIndex);
      Get.find<PaymentController>().selectOfflineBank(
          Get.find<ParcelController>().selectedOfflineBankIndex,
          canUpdate: false);
      await Get.find<PaymentController>()
          .getOfflineMethodList(widget.storeId.toString());
      Get.find<PaymentController>().changesMethod(canUpdate: false);
    }
    if (Get.find<PaymentController>().offlineMethodList == null) {
      await Get.find<PaymentController>()
          .getOfflineMethodList(widget.storeId.toString());
    }
    Get.find<PaymentController>().informationControllerList = [];
    Get.find<PaymentController>().informationFocusList = [];
    if (Get.find<PaymentController>().offlineMethodList != null &&
        Get.find<PaymentController>().offlineMethodList!.isNotEmpty) {
      for (int index = 0;
          index <
              Get.find<PaymentController>()
                  .offlineMethodList![
                      Get.find<PaymentController>().selectedOfflineBankIndex]
                  .methodInformations!
                  .length;
          index++) {
        Get.find<PaymentController>()
            .informationControllerList
            .add(TextEditingController());
        Get.find<PaymentController>().informationFocusList.add(FocusNode());
      }
    }
    Get.find<PaymentController>().initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'offline_payment'.tr),
      body: SafeArea(
        child: GetBuilder<PaymentController>(builder: (paymentController) {
          List<MethodInformations>? methodInformation =
              paymentController.offlineMethodList != null
                  ? paymentController
                      .offlineMethodList![
                          paymentController.selectedOfflineBankIndex]
                      .methodInformations!
                  : [];

          return paymentController.offlineMethodList != null
              ? Column(children: [
                  Expanded(
                      child: SingleChildScrollView(
                    child: FooterView(
                      child: SizedBox(
                        width: Dimensions.webMaxWidth,
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          Image.asset(Images.offlinePayment, height: 100),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          Text('pay_your_bill_using_the_info'.tr,
                              textAlign: TextAlign.center,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color,
                              )),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          SizedBox(
                            height: 200,
                            child: PageView.builder(
                                onPageChanged: (int pageIndex) {
                                  paymentController
                                      .selectOfflineBank(pageIndex);
                                  paymentController.changesMethod();
                                },
                                scrollDirection: Axis.horizontal,
                                controller: pageController,
                                itemCount:
                                    paymentController.offlineMethodList!.length,
                                itemBuilder: (context, index) {
                                  bool selected = paymentController
                                          .selectedOfflineBankIndex ==
                                      index;
                                  return Column(
                                    children: [
                                      bankCard(
                                          context,
                                          paymentController.offlineMethodList,
                                          index,
                                          selected),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.paddingSizeDefault -
                                                    5),
                                        child: InkWell(
                                          onTap: () {
                                            showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                builder: (con) =>
                                                    ScanQrBottomSheet(
                                                      imageUrl: paymentController
                                                          .offlineMethodList![
                                                              index]
                                                          .qrCodeUrl,
                                                    ));
                                          },
                                          child: TransactionErrorWidget(
                                            icon: Icons.arrow_forward_ios_sharp,
                                            sizeIcon: 18,
                                            txtColor: Colors.black,
                                            text: 'pay_via_qr'.tr,
                                            color: Theme.of(context).cardColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          ),
                          Text(
                            '${'amount'.tr} '
                            ' ${PriceConverter.convertPrice(widget.total)}',
                            style: robotoBold.copyWith(
                                fontSize: Dimensions.fontSizeLarge),
                          ),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraLarge),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeLarge),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'upload_your_transaction'.tr,
                                      style: robotoBold.copyWith(
                                          fontSize: Dimensions.fontSizeDefault),
                                    ),
                                  ),

                                  // CustomTextField(
                                  //   titleText: 'write_your_note'.tr,
                                  //   labelText: 'note'.tr,
                                  //   controller: _customerNoteController,
                                  //   focusNode: _customerNoteNode,
                                  //   inputAction: TextInputAction.done,
                                  // ),
                                  // Container(
                                  //   decoration: BoxDecoration(
                                  //       color: Theme.of(context).cardColor,
                                  //       borderRadius: BorderRadius.circular(
                                  //           Dimensions.radiusLarge),
                                  //       boxShadow: const [
                                  //         BoxShadow(
                                  //             color: Colors.black12,
                                  //             blurRadius: 5,
                                  //             spreadRadius: 1)
                                  //       ]),
                                  //   padding: const EdgeInsets.all(
                                  //       Dimensions.paddingSizeSmall),
                                  //   margin: const EdgeInsets.all(
                                  //       Dimensions.paddingSizeSmall),
                                  Padding(
                                    padding: EdgeInsets.all(
                                        Dimensions.paddingSizeDefault),
                                    child: OfflineImagePickWidget(
                                      paymentController: paymentController,
                                      radius: Dimensions.radiusLarge,
                                      width: MediaQuery.of(context).size.width,
                                      margin: 2,
                                      height: 200,
                                    ),
                                  )

                                  // Center(
                                  //   child: InkWell(
                                  //     onTap: () =>
                                  //         paymentController.pickImage(),
                                  //     child: paymentController.rawFile != null
                                  //         ? ClipRRect(
                                  //             borderRadius:
                                  //                 BorderRadius.circular(
                                  //                     Dimensions.radiusLarge),
                                  //             child: Image.memory(
                                  //               paymentController.rawFile!,
                                  //               width: 340,
                                  //               height: 150,
                                  //               fit: BoxFit.fill,
                                  //             ),
                                  //           )
                                  //         : Padding(
                                  //             padding: const EdgeInsets
                                  //                 .symmetric(
                                  //                 vertical: Dimensions
                                  //                         .paddingSizeLarge +
                                  //                     30),
                                  //             child: Image(
                                  //               image: AssetImage(
                                  //                   Images.cameraImg),
                                  //               color: Theme.of(context)
                                  //                   .primaryColor
                                  //                   .withValues(alpha: 0.3),
                                  //               width: 45,
                                  //               fit: BoxFit.cover,
                                  //             ),
                                  //           ),
                                  //   ),
                                  // ),
                                  // ),
                                  // ListView.builder(
                                  //   itemCount: paymentController
                                  //       .informationControllerList.length,
                                  //   shrinkWrap: true,
                                  //   physics:
                                  //       const NeverScrollableScrollPhysics(),
                                  //   padding: const EdgeInsets.symmetric(
                                  //       vertical: Dimensions.paddingSizeSmall),
                                  //   itemBuilder: (context, i) {
                                  //     return Padding(
                                  //       padding: const EdgeInsets.symmetric(
                                  //           vertical:
                                  //               Dimensions.paddingSizeSmall),
                                  //       child: CustomTextField(
                                  //         titleText: "Referrence ID",
                                  //         controller: paymentController
                                  //             .informationControllerList[i],
                                  //         focusNode: paymentController
                                  //             .informationFocusList[i],
                                  //         nextFocus: i !=
                                  //                 paymentController
                                  //                         .informationControllerList
                                  //                         .length -
                                  //                     1
                                  //             ? paymentController
                                  //                 .informationFocusList[i + 1]
                                  //             : _customerNoteNode,
                                  //         labelText: "Referrence ID",
                                  //         required: true,
                                  //       ),
                                  //     );
                                  //   },
                                  // ),

                                  ,
                                  const SizedBox(
                                      height: Dimensions.paddingSizeLarge),
                                ]),
                          ),
                          ResponsiveHelper.isDesktop(context)
                              ? completeButton(
                                  paymentController, methodInformation)
                              : const SizedBox(),
                        ]),
                      ),
                    ),
                  )),
                  !ResponsiveHelper.isDesktop(context)
                      ? completeButton(paymentController, methodInformation)
                      : const SizedBox(),
                ])
              : const Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }

  Widget completeButton(
    PaymentController paymentController,
    List<MethodInformations>? methodInformation,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeLarge,
          vertical: Dimensions.paddingSizeSmall),
      child: CustomButton(
        buttonText: 'complete'.tr,
        isLoading: paymentController.isLoading,
        width: ResponsiveHelper.isDesktop(context) ? 300 : 500,
        onPressed: () async {
          bool complete = false;
          String text = '';
          for (int i = 0; i < methodInformation!.length; i++) {
            if (paymentController.rawFile == null) {
              complete = false;
              // text = methodInformation[i].customerPlaceholder!;
              text = "Please upload your transaction image";
              break;
            } else {
              complete = true;
            }
          }

          if (complete) {
            String methodId = paymentController
                .offlineMethodList![paymentController.selectedOfflineBankIndex]
                .id
                .toString();

            String? orderId = '';
            if (widget.forParcel) {
              orderId = await Get.find<ParcelController>().placeOrder(
                  widget.placeOrderBody,
                  widget.zoneId,
                  widget.total,
                  widget.maxCodOrderAmount,
                  widget.fromCart,
                  widget.isCashOnDeliveryActive,
                  isOfflinePay: true,
                  forParcel: widget.forParcel);
            } else {
              orderId = await Get.find<CheckoutController>().placeOrder(
                  widget.placeOrderBody,
                  widget.zoneId,
                  widget.total,
                  widget.maxCodOrderAmount,
                  widget.fromCart,
                  widget.isCashOnDeliveryActive,
                  Get.find<CheckoutController>().pickedPrescriptions,
                  isOfflinePay: true);
            }

            if (orderId.isNotEmpty) {
              Map<String, String> data = {
                "_method": "post",
                "order_id": orderId,
                "method_id": methodId,
                // "customer_note": _customerNoteController.text,
              };

              for (int i = 0; i < methodInformation.length; i++) {
                data.addAll({
                  methodInformation[i].customerInput!:
                      paymentController.informationControllerList[i].text,
                });
              }

              paymentController
                  .saveOfflineInfo(jsonEncode(data))
                  .then((success) {
                if (success) {
                  Get.offAllNamed(RouteHelper.getOrderDetailsRoute(
                      int.parse(orderId!),
                      fromOffline: true,
                      contactNumber:
                          widget.placeOrderBody.contactPersonNumber));
                }
              });
            }
          } else {
            showCustomSnackBar(text);
          }
        },
      ),
    );
  }

  Widget bankCard(BuildContext context,
      List<OfflineMethodModel>? offlineMethodList, int index, bool selected) {
    return Container(
      decoration: BoxDecoration(
        color: selected
            ? Theme.of(context).cardColor
            : Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: selected
            ? const [
                BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)
              ]
            : [],
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                Text('bank_info'.tr,
                    style: robotoMedium.copyWith(
                        color: Theme.of(context).primaryColor)),
                const Spacer(),
                selected
                    ? Row(children: [
                        Text(
                          'pay_on_this_account'.tr,
                          style: robotoMedium.copyWith(
                              color: Theme.of(context).primaryColor),
                        ),
                        Icon(Icons.check_circle_rounded,
                            size: 20, color: Theme.of(context).primaryColor),
                      ])
                    : const SizedBox(),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              ListView.builder(
                  itemCount: offlineMethodList![index].methodFields!.length,
                  addRepaintBoundaries: false,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: Dimensions.paddingSizeExtraSmall),
                      child: Row(children: [
                        Text(
                          '${offlineMethodList[index].methodFields![i].inputName!.toString().replaceAll('_', ' ').capitalize} : ',
                          style: robotoMedium.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .color!
                                  .withValues(alpha: 0.5)),
                        ),
                        Flexible(
                          child: Text(
                              offlineMethodList[index]
                                  .methodFields![i]
                                  .inputData!,
                              style: robotoMedium,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ]),
                    );
                  }),
            ]),
      ),
    );
  }
}
