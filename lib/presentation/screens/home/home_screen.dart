import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_state.dart';

import '../../../presentation/widget/app_bar_widget.dart';
import '../../../presentation/screens/home/provider/home_provider.dart';
import '../../../presentation/widget/button_widget.dart';
import '../../../presentation/widget/error_widget.dart';
import '../../../presentation/widget/story_card_widget.dart';

import '../../../utils/router.dart';
import '../../../utils/date.dart';
import '../../../utils/color.dart';
import '../../../utils/locale.dart';

import '../../../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final homeProvider = context.read<HomeProvider>();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        if (homeProvider.page != null) {
          homeProvider.fetchStories(AppLocalizations.of(context)!.noInternet);
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false)
          .fetchStories(AppLocalizations.of(context)!.noInternet);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: appBarWidget("Story App", secondaryColor, authService, context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Consumer<HomeProvider>(
                builder: (context, value, child) {
                  final state = value.storyState;

                  if (state == ApiState.loading && value.page == 1) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: secondaryColor,
                      ),
                    );
                  } else if (homeProvider.hasError) {
                    return errorWidget(
                      'assets/svg/501.svg',
                      '${homeProvider.error}',
                    );
                  } else if (state == ApiState.loaded) {
                    final stories = value.listStory;
                    return ListView.builder(
                        controller: _scrollController,
                        itemCount:
                            stories.length + (value.page != null ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == stories.length && value.page != null) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final story = stories[index];
                          return GestureDetector(
                            onTap: () => context.goNamed(
                              "DETAIL",
                              pathParameters: {"id": story.id},
                            ),
                            child: storyCard(
                              homeAndDetailComponen(
                                story.photoUrl,
                                story.name,
                                formatDate(story.createdAt.toString(), context),
                                story.description,
                                story.id,
                              ),
                            ),
                          );
                        });
                  } else {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.noData,
                        style: const TextStyle(
                            color: secondaryColor, fontSize: 18),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 8,
            ),
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
}
