import 'package:flutter/material.dart';
import 'package:tostign/util/dimensions.dart';
import 'package:tostign/util/styles.dart';

class TransactionErrorWidget extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final Color? color;
  final Color? txtColor;
  final double? sizeIcon;
  const TransactionErrorWidget({
    this.icon,
    required this.color,
    this.sizeIcon,
    required this.text,
    required this.txtColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: color,
          boxShadow: [
            const BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 1,
            )
          ]),
      child: Row(children: [
        Expanded(
            child: Text(text!,
                style: robotoMedium.copyWith(color: txtColor),
                maxLines: 2,
                overflow: TextOverflow.ellipsis)),
        Icon(icon, size: sizeIcon),
      ]),
    );
  }
}
