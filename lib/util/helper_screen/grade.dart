import 'package:flutter/material.dart';

Color getGradeColor(String grade) {
  switch (grade) {
    case 'A':
      return Colors.green[700]!;
    case 'B':
      return Colors.blue[700]!;
    case 'C':
      return Colors.amber[700]!;
    case 'D':
      return Colors.orange[700]!;
    case 'F':
      return Colors.red[700]!;
    default:
      return Colors.grey[700]!;
  }
}