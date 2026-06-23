import 'package:flutter/material.dart';

Color stringToColor(String text) {
  var hash = 0;
  for (var i = 0; i < text.length; i++) {
    hash = text.codeUnitAt(i) + ((hash << 5) - hash);
  }
  final finalHash = hash.abs() % (256 * 256 * 256);
  final red = (finalHash & 0xFF0000) >> 16;
  final green = (finalHash & 0x00FF00) >> 8;
  final blue = (finalHash & 0x0000FF);
  return Color.fromRGBO(red, green, blue, 1.0);
}

class Avatar extends StatelessWidget {
  final String initials;
  final double size;
  final Color backgroundColor;
  final Color textColor;

  Avatar({
    super.key,
    required this.initials,
    this.size = 50,
    Color? backgroundColor,
    this.textColor = Colors.white,
  }) : backgroundColor = backgroundColor ?? stringToColor(initials);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: textColor,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
