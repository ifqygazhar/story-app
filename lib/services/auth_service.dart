import 'dart:async';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../data/local/token.dart';

class AuthService {
  final StreamController<bool> _onAuthStateChange =
      StreamController.broadcast();

  Stream<bool> get onAuthStateChange => _onAuthStateChange.stream;

  Future<bool> login() async {
    _onAuthStateChange.add(true);
    return true;
  }

  void logOut() async {
    _onAuthStateChange.add(false);
    DefaultCacheManager().emptyCache();
    await TokenManager.removeToken();
  }
}
