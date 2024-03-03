import 'package:freezed_annotation/freezed_annotation.dart';

part 'story.g.dart';

part 'story.freezed.dart';

@freezed
class Story with _$Story {
  const factory Story({
    required bool error,
    required String message,
    required List<ListStory> listStory,
  }) = _Story;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
}

@freezed
class ListStory with _$ListStory {
  const factory ListStory({
    required String id,
    required String name,
    required String description,
    required String photoUrl,
    required DateTime createdAt,
    required double? lat,
    required double? lon,
  }) = _ListStory;

  factory ListStory.fromJson(Map<String, dynamic> json) =>
      _$ListStoryFromJson(json);
}
