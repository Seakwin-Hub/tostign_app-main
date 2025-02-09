import 'package:flutter/material.dart';
import 'package:tostign/util/dimensions.dart';
import 'package:tostign/util/styles.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BLOG",
            style: robotoMedium.copyWith(
              fontSize: Dimensions.fontSizeLarge,
            )),
        backgroundColor: Colors.cyanAccent,
      ),
    );
  }
}
