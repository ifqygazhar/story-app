import 'package:flutter/material.dart';

import '../../utils/color.dart';

Widget inputWidget(String hintText, TextEditingController controller,
    bool condition, bool isEmail) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: primaryColor,
    ),
    child: TextField(
      controller: controller,
      keyboardType: isEmail == false ? null : TextInputType.emailAddress,
      obscureText: condition == false ? false : true,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w300,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
            fontSize: 15, color: Colors.white, fontWeight: FontWeight.w300),
        filled: true,
        fillColor: Colors.transparent,
        border: InputBorder.none,
      ),
    ),
  );
}
