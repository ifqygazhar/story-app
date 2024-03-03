import 'package:flutter/foundation.dart';

import '../../../../data/api/api_state.dart';
import '../../../../data/api/story.dart';
import '../../../../domain/entities/story.dart';

class HomeProvider extends ChangeNotifier {
  final StoryApi _storyApi;

  HomeProvider(this._storyApi);

  List<ListStory> listStory = [];
  ApiState storyState = ApiState.initial;
  String storyMessage = "";

  bool storyError = false;
  Object? _error;
  int? page = 1;
  int size = 10;

  bool get hasError => _error != null;
  Object? get error => _error;

  Future<void> fetchStories(String error) async {
    try {
      if (page == 1) {
        storyState = ApiState.loading;

        notifyListeners();
      }

      final result = await _storyApi.fetchAllStories(error, page!, size);
      if (!result.data['error']) {
        final story = Story.fromJson(result.data);
        listStory.addAll(story.listStory);

        storyMessage = "Success";
        storyError = false;
        storyState = ApiState.loaded;

        if (story.listStory.length < size) {
          page = null;
        } else {
          page = page! + 1;
        }

        notifyListeners();
      } else {
        return result.data['message'];
      }
    } catch (e) {
      String errorMessage = error.toString();

      if (errorMessage.contains('Exception:')) {
        errorMessage = errorMessage.replaceAll('Exception:', '');
      }

      _error = errorMessage.trim();

      storyState = ApiState.error;
      storyError = true;
      storyMessage = "Get quotes failed";
      notifyListeners();
    }
  }
}
