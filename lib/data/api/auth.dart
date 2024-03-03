import 'package:dio/dio.dart';

import '../../utils/endpoints.dart';

class AuthApi {
  final Dio dio;

  const AuthApi({required this.dio});

  Future<Response> registerUser(
      Map<String, dynamic> userData, String error) async {
    try {
      return await dio.post(register, data: userData);
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 400) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(error);
      }
    }
  }

  Future<Response> login(Map<String, dynamic> userData, String error) async {
    try {
      return await dio.post(loginURI, data: userData);
    } on DioException catch (e) {
      // Tangani kesalahan dari respons API
      if (e.response != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(error);
      }
    }
  }
}
