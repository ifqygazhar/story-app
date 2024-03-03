import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../presentation/screens/story/provider/location_provider.dart';
import '../../../utils/color.dart';

class MapScreen extends StatefulWidget {
  final String? lat;
  final String? long;
  final bool isSelecting;

  const MapScreen({
    super.key,
    this.lat,
    this.long,
    this.isSelecting = true,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  void _saveLocation(LatLng pickedLocation) {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    locationProvider.setLat = pickedLocation.latitude;
    locationProvider.setLong = pickedLocation.longitude;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: const Text(
          "Map Screen",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              GoRouter.of(context).pop(_pickedLocation);
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Center(
        child: GoogleMap(
          onTap: !widget.isSelecting
              ? null
              : (position) {
                  setState(() {
                    _pickedLocation = position;
                    _saveLocation(_pickedLocation!);
                  });
                },
          initialCameraPosition: CameraPosition(
            target: LatLng(
              double.parse(widget.lat!),
              double.parse(widget.long!),
            ),
            zoom: 16,
          ),
          markers: (_pickedLocation == null && widget.isSelecting)
              ? {}
              : {
                  Marker(
                    markerId: const MarkerId('m1'),
                    position: _pickedLocation ??
                        LatLng(
                          double.parse(widget.lat!),
                          double.parse(widget.long!),
                        ),
                  ),
                },
        ),
      ),
    );
  }
}
