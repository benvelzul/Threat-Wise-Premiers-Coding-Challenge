import 'package:flutter/material.dart';


class LocalImageWidget extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;

  LocalImageWidget({
    required this.imagePath,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.contain, // Scales the full image to fit within the bounds
      ),
    );
  }
}
