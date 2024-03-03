import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/local/token.dart';
import '../../../presentation/widget/auth_card_widget.dart';
import '../../../presentation/widget/button_widget.dart';
import '../../../presentation/widget/input_widget.dart';

import '../../../utils/color.dart';
import '../../../utils/locale.dart';
import '../../../utils/router.dart';

import '../../../services/auth_service.dart';
import 'provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

    _emailController.dispose();
    _passwordController.dispose();
    _tapGestureRecognizer.dispose();
  }

  void _onTapPress() {
    GoRouter.of(context).goNamed(APP_PAGE.register.toName);
  }

  void _login(BuildContext context) async {
    Map<String, dynamic> userData = {
      'email': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
    };

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    dynamic loginResult = await authProvider.login(
      userData,
      AppLocalizations.of(context)!.noInternet,
    );

    if (loginResult is String) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loginResult)),
      );
    } else if (loginResult is Map<String, dynamic>) {
      if (loginResult['token'] != null) {
        String token = loginResult['token'];
        await TokenManager.saveToken(token);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.successLogin)),
        );
        authService.login();
      } else {
        String errorMessage =
            loginResult['message'] ?? 'Login failed. Please try again.';
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } else {
      return null;
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
            SvgPicture.asset("assets/svg/login.svg"),
            const SizedBox(
              height: 12,
            ),
            authCard(
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    inputWidget("Email", _emailController, false, true),
                    const SizedBox(
                      height: 10,
                    ),
                    inputWidget("Password", _passwordController, true, false),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: double.infinity,
              child: button(
                AppLocalizations.of(context)!.login,
                () => _login(context),
                const Icon(Icons.login),
              ),
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
                        .loginText
                        .replaceAll("Register", ""),
                  ),
                  TextSpan(
                    text: "Register",
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
