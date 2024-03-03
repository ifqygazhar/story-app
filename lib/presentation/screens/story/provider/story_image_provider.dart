import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class ImageStoryProvider extends ChangeNotifier {
  String? _imagePath;

  XFile? _imageFile;

  String? get getImagePath => _imagePath;
  XFile? get getImageFile => _imageFile;

  saveImagePath(String? value) {
    _imagePath = value;
    notifyListeners();
  }

  saveImageFile(XFile? value) {
    _imageFile = value;
    notifyListeners();
  }
}
