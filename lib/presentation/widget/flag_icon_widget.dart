import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/utils/color.dart';

import '../../global/provider/locale_provider.dart';
import '../../utils/locale.dart';

class FlagIconWidget extends StatelessWidget {
  const FlagIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        dropdownColor: primaryColor,
        icon: const Icon(Icons.flag),
        items: AppLocalizations.supportedLocales.map((Locale locale) {
          final flag = Localization.getFlag(locale.languageCode);
          return DropdownMenuItem(
            value: locale,
            child: Center(
              child: Text(
                flag,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            onTap: () {
              final provider =
                  Provider.of<LocalizationProvider>(context, listen: false);
              provider.setLocale(locale);
            },
          );
        }).toList(),
        onChanged: (_) {},
      ),
    );
  }
}
