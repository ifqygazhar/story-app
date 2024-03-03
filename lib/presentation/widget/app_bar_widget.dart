import 'package:flutter/material.dart';
import 'package:story_app/presentation/widget/flag_icon_widget.dart';
import '../../services/auth_service.dart';

AppBar appBarWidget(
    String title, Color color, AuthService authService, BuildContext context) {
  return AppBar(
    backgroundColor: color,
    title: Text(
      title,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 15,
      ),
    ),
    actions: [
      const FlagIconWidget(),
      IconButton(
        onPressed: () {
          authService.logOut();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Logout Berhasil"),
            ),
          );
        },
        icon: const Icon(Icons.logout),
      ),
    ],
  );
}
