import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../presentation/widget/location_widget.dart';
import '../../../presentation/widget/app_bar_widget.dart';
import '../../../presentation/widget/button_widget.dart';
import '../../../presentation/widget/error_widget.dart';
import '../../../presentation/widget/story_card_widget.dart';

import '../../../utils/color.dart';
import '../../../utils/date.dart';
import '../../../utils/locale.dart';
import '../../../utils/router.dart';

import '../../../presentation/screens/story/provider/story_provider.dart';

import '../../../services/auth_service.dart';

class DetailScreen extends StatelessWidget {
  final String id;
  const DetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: appBarWidget("Detail", secondaryColor, authService, context),
      body: FutureBuilder(
        future: Provider.of<StoryProvider>(context).fetchStoryById(
          id,
          AppLocalizations.of(context)!.noInternet,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: secondaryColor,
              ),
            );
          } else if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data == null) {
            return errorWidget('assets/svg/501.svg', "${snapshot.error}");
          } else {
            final story = snapshot.data!.story;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    storyCard(
                      homeAndDetailComponen(
                        story.photoUrl,
                        story.name,
                        formatDate(story.createdAt.toString(), context),
                        story.description,
                        story.id,
                      ),
                    ),
                    LocationInput(
                      isDetail: true,
                      lat: story.lat,
                      long: story.lon,
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: button(
                        AppLocalizations.of(context)!.addStory,
                        () => context.goNamed(APP_PAGE.upload.toName),
                        const Icon(Icons.create),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
