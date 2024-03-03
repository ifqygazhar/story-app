import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../utils/color.dart';
import '../../utils/locale.dart';
import 'input_widget.dart';

Container storyCard(Widget widget) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: secondaryColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(padding: const EdgeInsets.all(16), child: widget),
  );
}

Column homeAndDetailComponen(
    String image, String name, String date, String description, String tag) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Center(
        child: Hero(
          tag: tag,
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: image,
            errorWidget: (context, url, error) => const Icon(
              Icons.error,
            ),
            placeholder: (context, url) => Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(
                color: primaryColor,
              ),
            ),
            cacheManager: DefaultCacheManager(),
            fadeInDuration: const Duration(milliseconds: 500),
          ),
        ),
      ),
      const SizedBox(
        height: 12,
      ),
      Text(
        name,
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15),
      ),
      const SizedBox(
        height: 12,
      ),
      Text(
        date,
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
      ),
      const SizedBox(
        height: 12,
      ),
      Text(
        description,
        textAlign: TextAlign.justify,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      )
    ],
  );
}

Column imageCardComponen(
  String image,
  BuildContext context,
  TextEditingController description,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Center(
        child: Image.file(
          File(image),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
      const SizedBox(
        height: 12,
      ),
      inputWidget(
        AppLocalizations.of(context)!.description,
        description,
        false,
        false,
      ),
    ],
  );
}
