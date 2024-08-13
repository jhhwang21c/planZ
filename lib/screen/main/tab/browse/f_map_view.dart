// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class MapView extends StatefulWidget {
//   final GeoPoint? spotLocation;
//
//   const MapView({Key? key, this.spotLocation}) : super(key: key);
//
//   @override
//   State<MapView> createState() => _MapViewState();
// }
//
// class _MapViewState extends State<MapView> {
//   LocationData? currentLocation;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.spotLocation == null) {
//       getCurrentLocation();
//     }
//   }
//
//   void getCurrentLocation() async {
//     Location location = Location();
//
//     bool serviceEnabled;
//     PermissionStatus permissionGranted;
//
//     // Check if location service is enabled
//     serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) {
//         return;
//       }
//     }
//
//     // Check for location permissions
//     permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }
//
//     // Get the current location
//     location.getLocation().then((locationData) {
//       setState(() {
//         currentLocation = locationData;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return (widget.spotLocation == null && currentLocation == null)
//         ? const Center(child: Text("Loading location"))
//         : GoogleMap(
//       initialCameraPosition: CameraPosition(
//         target: widget.spotLocation != null
//             ? LatLng(widget.spotLocation!.latitude, widget.spotLocation!.longitude)
//             : LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
//         zoom: 15.0,
//       ),
//       markers: {
//         if (widget.spotLocation != null)
//           Marker(
//             markerId: const MarkerId("spot"),
//             position: LatLng(widget.spotLocation!.latitude, widget.spotLocation!.longitude),
//           ),
//         if (currentLocation != null)
//           Marker(
//             markerId: const MarkerId("current"),
//             position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
//           ),
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapView extends StatefulWidget {
  final GeoPoint? spotLocation;

  const MapView({Key? key, this.spotLocation}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  LocationData? _currentLocation;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    if (widget.spotLocation == null) {
      _fetchCurrentLocation();
    }
  }

  Future<void> _fetchCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location services are enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // Check for location permissions
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Get the current location
    final currentLocation = await location.getLocation();
    setState(() {
      _currentLocation = currentLocation;
      _moveCameraToLocation(
        LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
      );
    });
  }

  void _moveCameraToLocation(LatLng target) {
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: 15.0),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.spotLocation != null
            ? LatLng(widget.spotLocation!.latitude, widget.spotLocation!.longitude)
            : const LatLng(0, 0), // Default to 0,0 if current location is not yet fetched
        zoom: 15.0,
      ),
      markers: {
        if (widget.spotLocation != null)
          Marker(
            markerId: const MarkerId("spot"),
            position: LatLng(widget.spotLocation!.latitude, widget.spotLocation!.longitude),
          ),
        if (_currentLocation != null)
          Marker(
            markerId: const MarkerId("current"),
            position: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
          ),
      },
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
        if (_currentLocation != null && widget.spotLocation == null) {
          _moveCameraToLocation(
            LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
          );
        }
      },
    );
  }
}