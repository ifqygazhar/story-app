import 'package:flutter/foundation.dart';

import '../../../../data/api/auth.dart';

class AuthProvider extends ChangeNotifier {
  final AuthApi _authApi;

  AuthProvider(this._authApi);

  Future<String?> registerUser(
      Map<String, dynamic> userData, String error) async {
    try {
      final response = await _authApi.registerUser(userData, error);

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

      return errorMessage.trim();
    }
  }

  Future<dynamic> login(Map<String, dynamic> userData, String error) async {
    try {
      final response = await _authApi.login(userData, error);
      if (response.data['error']) {
        return response.data["messages"];
      } else {
        return response.data['loginResult'];
      }
    } catch (error) {
      String errorMessage = error.toString();

      if (errorMessage.contains('Exception:')) {
        errorMessage = errorMessage.replaceAll('Exception:', '');
      }

      return errorMessage.trim();
    }
  }
}
