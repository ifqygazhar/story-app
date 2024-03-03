import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';

import '../../../presentation/widget/button_widget.dart';
import '../../../utils/color.dart';
import '../../../utils/locale.dart';
import '../../../services/service.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appService = Provider.of<AppService>(context, listen: false);
    return Scaffold(
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            SvgPicture.asset('assets/svg/onboard.svg'),
            const SizedBox(
              height: 12,
            ),
            Text(
              AppLocalizations.of(context)!.titleOnboard,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            const SizedBox(
              height: 22,
            ),
            Text(
              AppLocalizations.of(context)!.descriptionOnboard,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 18,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child:
                  button(AppLocalizations.of(context)!.buttonOnboardText, () {
                appService.onboarding = true;
              }, const Icon(Icons.start)),
            ),
          ],
        ),
      ),
    );
  }
}
