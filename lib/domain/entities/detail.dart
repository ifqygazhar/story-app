import 'package:freezed_annotation/freezed_annotation.dart';

part 'detail.g.dart';

part 'detail.freezed.dart';

@freezed
class DetailStory with _$DetailStory {
  const factory DetailStory({
    required bool error,
    required String message,
    required Story story,
  }) = _DetailStory;

  factory DetailStory.fromJson(Map<String, dynamic> json) =>
      _$DetailStoryFromJson(json);
}

@freezed
class Story with _$Story {
  const factory Story({
    required String id,
    required String name,
    required String description,
    required String photoUrl,
    required DateTime createdAt,
    required double? lat,
    required double? lon,
  }) = _Story;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
}
