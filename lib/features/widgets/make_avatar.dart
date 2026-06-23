import 'package:flutter/material.dart';
import 'string_to_color.dart';

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
      alignment: Alignment.centerRight,
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
