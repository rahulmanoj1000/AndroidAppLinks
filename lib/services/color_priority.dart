import 'package:flutter/material.dart';

class ColorPriority {
  Map<String, Color> colorMap = {
    'Low Priority': Colors.white,
    'High Priority': const Color.fromARGB(255, 255, 94, 0),
    'Medium Priority': const Color.fromARGB(255, 252, 227, 8),
    'Completed': Colors.green,
  };
  Color? colour(String priority) {
    return colorMap[priority];
  }
}
