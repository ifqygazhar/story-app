import 'package:flutter/material.dart';

import '../../utils/color.dart';

Container authCard(Widget child) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: secondaryColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: child,
  );
}
