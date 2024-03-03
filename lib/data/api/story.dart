import 'package:dio/dio.dart';

import '../../data/local/token.dart';
import '../../utils/endpoints.dart';

class StoryApi {
  final Dio dio;

  const StoryApi({required this.dio});

  Future<Response> fetchAllStories(String error,
      [int page = 1, int size = 10]) async {
    final token = await TokenManager.getToken();

    try {
      return await dio.get(
        stories,
        queryParameters: {
          'page': page,
          'size': size,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 400) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(error);
      }
    }
  }

  Future<Response> fetchStoryById(String id, String errorMessage) async {
    final token = await TokenManager.getToken();

    try {
      return await dio.get(
        "$stories/$id",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 400) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(errorMessage);
      }
    }
  }

  Future<Response> addStory(
      Map<String, dynamic> data, String errorMessage) async {
    final token = await TokenManager.getToken();
    FormData formData = FormData.fromMap(data);

    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      return await dio.post(stories, data: formData);
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 400) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(errorMessage);
      }
    }
  }
}
