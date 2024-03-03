import 'package:flutter/material.dart';

import '../../utils/color.dart';

ElevatedButton button(String title, Function() onTap, Icon icon) {
  return ElevatedButton.icon(
    onPressed: onTap,
    icon: icon,
    style: ElevatedButton.styleFrom(
      backgroundColor: secondaryColor,
      foregroundColor: Colors.black,
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    label: Text(title),
  );
}
