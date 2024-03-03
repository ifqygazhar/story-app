import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../presentation/widget/auth_card_widget.dart';
import '../../../presentation/widget/button_widget.dart';
import '../../../presentation/widget/input_widget.dart';

import '../../../utils/color.dart';
import '../../../utils/locale.dart';
import '../../../utils/router.dart';

import 'provider/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initState() {
    super.initState();
    _tapGestureRecognizer = TapGestureRecognizer()..onTap = _onTapPress;
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _tapGestureRecognizer.dispose();
  }

  void _onTapPress() {
    context.goNamed(APP_PAGE.login.toName);
  }

  void _registerUser(BuildContext context) async {
    Map<String, dynamic> userData = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'password': _passwordController.text,
    };

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    var message = await authProvider.registerUser(
      userData,
      AppLocalizations.of(context)!.noInternet,
    );

    if (message == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.successRegister),
        ),
      );
      context.goNamed(APP_PAGE.login.toName);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/svg/register.svg"),
            const SizedBox(
              height: 12,
            ),
            authCard(
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    inputWidget(
                      AppLocalizations.of(context)!.nameInput,
                      _nameController,
                      false,
                      false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    inputWidget("Email", _emailController, false, true),
                    const SizedBox(
                      height: 10,
                    ),
                    inputWidget(
                      "Password",
                      _passwordController,
                      true,
                      false,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: double.infinity,
              child: button(AppLocalizations.of(context)!.register,
                  () => _registerUser(context), const Icon(Icons.create)),
            ),
            const SizedBox(
              height: 12,
            ),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: AppLocalizations.of(context)!
                        .registerText
                        .replaceAll("Login", ""),
                  ),
                  TextSpan(
                    text: "Login",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: secondaryColor,
                    ),
                    recognizer: _tapGestureRecognizer,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
