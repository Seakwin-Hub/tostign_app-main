import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:tostign/features/payment/controllers/payment_controller.dart';
import 'package:tostign/util/dimensions.dart';
import 'package:tostign/util/images.dart';

class OfflineImagePickWidget extends StatelessWidget {
  const OfflineImagePickWidget({
    required this.paymentController,
    this.radius,
    this.width,
    this.margin,
    this.height,
    super.key,
  });

  final PaymentController? paymentController;
  final double? radius;
  final double? width;
  final double? margin;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: Theme.of(context).primaryColor,
      dashPattern: [9, 4],
      borderType: BorderType.RRect,
      radius: Radius.circular(radius!),
      child: Container(
        width: width,
        margin: EdgeInsets.all(margin!),
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          color: const Color.fromARGB(255, 234, 234, 234),
        ),
        child: InkWell(
          onTap: () => paymentController!.pickImage(),
          child: paymentController!.rawFile != null
              ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(radius!),
                      child: Image.memory(
                        paymentController!.rawFile!,
                        width: 340,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(radius!)),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 3, color: Colors.white),
                              shape: BoxShape.circle,
                            ),
                            child: Image(
                              image: AssetImage(Images.cameraImg),
                              width: 34,
                              fit: BoxFit.cover,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeLarge + 30),
                  child: Center(
                    child: Image(
                      image: AssetImage(Images.cameraImg),
                      width: 45,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
