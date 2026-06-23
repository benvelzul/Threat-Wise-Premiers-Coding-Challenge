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