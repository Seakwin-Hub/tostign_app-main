import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tostign/common/widgets/custom_image.dart';
import 'package:tostign/util/dimensions.dart';
import 'package:tostign/util/styles.dart';

class ScanQrBottomSheet extends StatefulWidget {
  final String? imageUrl;
  const ScanQrBottomSheet({super.key, required this.imageUrl});

  @override
  State<ScanQrBottomSheet> createState() => _ScanQrBottomSheetState();
}

class _ScanQrBottomSheetState extends State<ScanQrBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 550,
      margin: EdgeInsets.only(top: 30),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(Dimensions.radiusExtraLarge),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeLarge,
        ),
        child: Column(
          children: [
            Container(
              height: 4,
              width: 35,
              margin: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor,
                  borderRadius: BorderRadius.circular(10)),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('scan_qr_payment'.tr,
                  style: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeDefault)),
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.clear, color: Theme.of(context).disabledColor),
              )
            ]),
            widget.imageUrl != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeLarge),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusDefault),
                      child: CustomImage(
                        image: widget.imageUrl!,
                        width: 250,
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
