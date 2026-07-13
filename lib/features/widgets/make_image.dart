import 'package:flutter/material.dart';


class LocalImageWidget extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;

  const LocalImageWidget({super.key, 
    required this.imagePath,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Failed to load asset: $imagePath\n$error');
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.broken_image_outlined, color: Colors.white54),
          );
        },
      ),
    );
  }
}
