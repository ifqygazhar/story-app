import 'package:flutter/foundation.dart';

class LocationProvider extends ChangeNotifier {
  double? _lat;
  double? _long;

  get getLat => _lat;
  get getLong => _long;

  set setLat(double? value) {
    _lat = value;
  }

  set setLong(double? value) {
    _long = value;
  }
}
