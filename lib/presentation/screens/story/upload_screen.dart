import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../presentation/screens/home/provider/home_provider.dart';
import '../../../presentation/screens/story/provider/location_provider.dart';
import '../../../presentation/widget/location_widget.dart';

import '../../../presentation/screens/story/provider/story_provider.dart';
import '../../../presentation/screens/story/provider/story_image_provider.dart';
import '../../../presentation/widget/app_bar_widget.dart';
import '../../../presentation/widget/button_widget.dart';
import '../../../presentation/widget/story_card_widget.dart';

import '../../../services/auth_service.dart';

import '../../../utils/color.dart';
import '../../../utils/locale.dart';
import '../../../utils/router.dart';
import '../../../utils/flavor/flavor_mode_config.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({
    super.key,
  });

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final TextEditingController _description = TextEditingController();

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  void _takePicture() async {
    final cameras = await availableCameras();
    final provider = context.read<ImageStoryProvider>();

    context.goNamed(
      APP_PAGE.camera.toName,
      extra: cameras,
    );

    if (provider.getImageFile != null) {
      provider.saveImageFile(provider.getImageFile);
      provider.saveImagePath(provider.getImagePath);
    }
  }

  void _imageFromGallery() async {
    final provider = context.read<ImageStoryProvider>();
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      provider.saveImageFile(pickedFile);
      provider.saveImagePath(pickedFile.path);
    }
  }

  void _upload() async {
    final imageProvider = context.read<ImageStoryProvider>();
    final locationProvider = context.read<LocationProvider>();

    if (imageProvider.getImagePath == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.imageNotFound,
          ),
        ),
      );
    } else if (_description.text.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.descriptionNotFound,
          ),
        ),
      );
    } else {
      Map<String, dynamic> data = {
        'description': _description.text.trim(),
        'photo': await MultipartFile.fromFile(imageProvider.getImagePath!),
        'lat': locationProvider.getLat ?? 0,
        'lon': locationProvider.getLong ?? 0,
      };

      final provider = Provider.of<StoryProvider>(context, listen: false);

      var message = await provider.addStory(
        data,
        AppLocalizations.of(context)!.noInternet,
      );

      if (message == null) {
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.successUpload,
            ),
          ),
        );
        context.goNamed(APP_PAGE.home.toName);
        context.read<HomeProvider>().listStory.clear();
        context.read<HomeProvider>().page = 1;

        context
            .read<HomeProvider>()
            .fetchStories(AppLocalizations.of(context)!.noInternet);
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final imageProvider = Provider.of<ImageStoryProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: primaryColor,
      appBar: appBarWidget("New Story", secondaryColor, authService, context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              imageProvider.getImageFile != null
                  ? storyCard(
                      imageCardComponen(imageProvider.getImageFile!.path,
                          context, _description),
                    )
                  : storyCard(
                      const Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.image,
                          size: 100,
                        ),
                      ),
                    ),
              _cameraGalleryButton(),
              const SizedBox(
                height: 8,
              ),
              if (!FlutterModeConfig.isFree)
                const LocationInput(isDetail: false),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: double.infinity,
                child:
                    button("Upload", () => _upload(), const Icon(Icons.upload)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Row _cameraGalleryButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        button(
          AppLocalizations.of(context)!.camera,
          () => _takePicture(),
          const Icon(Icons.camera),
        ),
        button(
          AppLocalizations.of(context)!.gallery,
          () => _imageFromGallery(),
          const Icon(Icons.image),
        ),
      ],
    );
  }
}
