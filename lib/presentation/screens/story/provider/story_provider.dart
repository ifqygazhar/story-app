import 'package:flutter/foundation.dart';

import '../../../../data/api/story.dart';
import '../../../../domain/entities/detail.dart';

class StoryProvider extends ChangeNotifier {
  final StoryApi _storyApi;

  StoryProvider(this._storyApi);

  Future<DetailStory> fetchStoryById(String id, String errorMessage) async {
    try {
      final response = await _storyApi.fetchStoryById(id, errorMessage);

      if (!response.data['error']) {
        final detailStory = DetailStory.fromJson(response.data);

        return detailStory;
      } else {
        throw Exception(response.data['message'] ?? 'Unknown error occurred');
      }
    } catch (error) {
      String errorMessage = error.toString();

      if (errorMessage.contains('Exception:')) {
        errorMessage = errorMessage.replaceAll('Exception:', '');
      }

      throw errorMessage.trim();
    }
  }

  Future<String?> addStory(
      Map<String, dynamic> data, String errorMessage) async {
    try {
      final response = await _storyApi.addStory(data, errorMessage);
      if (!response.data['error']) {
        return null;
      } else {
        return response.data['message'];
      }
    } catch (error) {
      String errorMessage = error.toString();

      if (errorMessage.contains('Exception:')) {
        errorMessage = errorMessage.replaceAll('Exception:', '');
      }

      throw errorMessage.trim();
    }
  }
}
