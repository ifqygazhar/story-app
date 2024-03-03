// ignore_for_file: non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:provider/provider.dart';
import 'package:location/location.dart';

import '../../presentation/widget/button_widget.dart';

import '../../utils/color.dart';
import '../../utils/endpoints.dart';
import '../../utils/locale.dart';
import '../../utils/router.dart';

import '../screens/story/provider/location_provider.dart';

class LocationInput extends StatefulWidget {
  final bool isDetail;
  final double? lat;
  final double? long;

  const LocationInput({super.key, this.lat, this.long, required this.isDetail});

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  double? LAT;
  double? LONG;
  String? address;

  bool isOpen = false;

  var _isGettingLocation = false;

  String get inputlocationImage {
    if (LAT == null) {
      return '';
    }

    return '$MAP_URL?center=$LAT,$LONG=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$LAT,$LONG&key=$API_KEY';
  }

  String get locationInDetail {
    final lat = widget.lat;
    final lng = widget.long;

    return '$MAP_URL?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=$API_KEY';
  }

  void _pressMapInDetail() async {
    final info = await geo.placemarkFromCoordinates(
        widget.lat ?? LAT!, widget.long ?? LONG!);

    final place = info[0];

    final newAddress =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    setState(() {
      address = newAddress;
      isOpen = true;
    });
  }

  void _map() async {
    Location location = Location();
    final currentLocation = await location.getLocation();

    final pickLocation =
        await context.pushNamed<LatLng>(APP_PAGE.map.toName, pathParameters: {
      "lat": currentLocation.latitude.toString(),
      "long": currentLocation.longitude.toString(),
    });

    if (pickLocation == null) {
      return;
    }

    setState(() {
      _isGettingLocation = true;
    });

    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    locationProvider.setLat = pickLocation.latitude;
    locationProvider.setLong = pickLocation.longitude;

    setState(() {
      LAT = pickLocation.latitude;
      LONG = pickLocation.longitude;
      _isGettingLocation = false;
    });
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();

    final lat = locationData.latitude;
    final lng = locationData.longitude;

    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    locationProvider.setLat = lat;
    locationProvider.setLong = lng;

    if (lat == null || lng == null) {
      return;
    }

    setState(() {
      LAT = lat;
      LONG = lng;
      _isGettingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Container(
      width: double.infinity,
      height: 170,
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(
          Radius.circular(
            8,
          ),
        ),
      ),
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.noLocation,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black, fontSize: 15),
        ),
      ),
    );

    if (LAT != null || widget.lat != null) {
      previewContent = Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (isOpen == false) {
                _pressMapInDetail();
              }

              setState(() {
                isOpen = false;
              });
            },
            child: CachedNetworkImage(
              imageUrl: widget.isDetail == true
                  ? locationInDetail
                  : inputlocationImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorWidget: (context, url, error) => const Icon(
                Icons.error,
              ),
              placeholder: (context, url) => Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  color: primaryColor,
                ),
              ),
              cacheManager: DefaultCacheManager(),
              fadeInDuration: const Duration(milliseconds: 200),
            ),
          ),
          if (address != null && isOpen)
            Positioned(
              top: 10,
              left: 18,
              right: 18,
              child: Card(
                elevation: 4,
                color: secondaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    address!,
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
        ],
      );
    }

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator(
        color: secondaryColor,
      );
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          child: previewContent,
        ),
        const SizedBox(
          height: 8,
        ),
        widget.isDetail == false
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  button(
                    AppLocalizations.of(context)!.getMyLocation,
                    _getCurrentLocation,
                    const Icon(Icons.location_on),
                  ),
                  button(
                    AppLocalizations.of(context)!.selectOnMap,
                    _map,
                    const Icon(Icons.map),
                  ),
                ],
              )
            : const SizedBox(),
      ],
    );
  }
}
