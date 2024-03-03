// ignore_for_file: camel_case_types

enum APP_PAGE {
  login,
  register,
  home,
  error,
  onBoarding,
  splash,
  upload,
  camera,
  detail,
  map,
}

extension AppPageExtension on APP_PAGE {
  String get toPath {
    switch (this) {
      case APP_PAGE.home:
        return "/";
      case APP_PAGE.login:
        return "/login";
      case APP_PAGE.splash:
        return "/splash";
      case APP_PAGE.register:
        return "/register";
      case APP_PAGE.detail:
        return "detail/:id";
      case APP_PAGE.upload:
        return "upload";
      case APP_PAGE.camera:
        return "camera";
      case APP_PAGE.map:
        return "map/:lat/:long";
      case APP_PAGE.error:
        return "/error";
      case APP_PAGE.onBoarding:
        return "/start";
      default:
        return "/";
    }
  }

  String get toName {
    switch (this) {
      case APP_PAGE.home:
        return "HOME";
      case APP_PAGE.login:
        return "LOGIN";
      case APP_PAGE.splash:
        return "SPLASH";
      case APP_PAGE.detail:
        return "DETAIL";
      case APP_PAGE.register:
        return "REGISTER";
      case APP_PAGE.upload:
        return "UPLOAD";
      case APP_PAGE.map:
        return "MAP";
      case APP_PAGE.camera:
        return "CAMERA";
      case APP_PAGE.error:
        return "ERROR";
      case APP_PAGE.onBoarding:
        return "START";
      default:
        return "HOME";
    }
  }
}
