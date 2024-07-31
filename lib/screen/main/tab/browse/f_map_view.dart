// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
//
// class MapView extends StatefulWidget {
//   final LatLng? spotLocation;
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
//   void initState() {
//     if (widget.spotLocation == null) {
//       getCurrentLocation();
//     }
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         (widget.spotLocation == null && currentLocation == null)
//             ? const Center(child: Text("Loading location"))
//             : GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target: widget.spotLocation ?? LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
//             zoom: 15.0,
//           ),
//           markers: {
//             if (widget.spotLocation != null)
//               Marker(
//                 markerId: const MarkerId("spot"),
//                 position: widget.spotLocation!,
//               ),
//             if (currentLocation != null)
//               Marker(
//                 markerId: const MarkerId("current"),
//                 position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
//               ),
//           },
//         ),
//         DraggableScrollableSheet(
//           initialChildSize: 0.3,
//           minChildSize: 0.3,
//           maxChildSize: 0.8,
//           builder: (BuildContext context, ScrollController scrollController) {
//             return Container(
//               color: Colors.blue,
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapView extends StatefulWidget {
  final String? spotLocationString;

  const MapView({Key? key, this.spotLocationString}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  LocationData? currentLocation;
  LatLng? spotLocation;

  @override
  void initState() {
    super.initState();
    if (widget.spotLocationString != null) {
      spotLocation = _parseLocation(widget.spotLocationString!);
    } else {
      getCurrentLocation();
    }
  }

  LatLng _parseLocation(String location) {
    final regex = RegExp(
        r'^(-?\d+\.\d+)°\s?([NS]),\s?(-?\d+\.\d+)°\s?([EW])$');
    final match = regex.firstMatch(location);

    if (match != null) {
      double lat = double.parse(match.group(1)!);
      double lng = double.parse(match.group(3)!);

      if (match.group(2) == 'S') {
        lat = -lat;
      }
      if (match.group(4) == 'W') {
        lng = -lng;
      }

      return LatLng(lat, lng);
    }

    throw Exception('Invalid location format');
  }

  void getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location service is enabled
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
    location.getLocation().then((locationData) {
      setState(() {
        currentLocation = locationData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        (spotLocation == null && currentLocation == null)
            ? const Center(child: Text("Loading location"))
            : GoogleMap(
          initialCameraPosition: CameraPosition(
            target: spotLocation ?? LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            zoom: 15.0,
          ),
          markers: {
            if (spotLocation != null)
              Marker(
                markerId: const MarkerId("spot"),
                position: spotLocation!,
              ),
            if (currentLocation != null)
              Marker(
                markerId: const MarkerId("current"),
                position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
              ),
          },
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.3,
          minChildSize: 0.3,
          maxChildSize: 0.8,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              color: Colors.blue,
            );
          },
        ),
      ],
    );
  }
}