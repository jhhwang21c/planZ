// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:math' as math;
//
// class PlanMapView extends StatefulWidget {
//   final List<Map<String, dynamic>>? locations; // List of locations with their spot data
//
//   const PlanMapView({Key? key, this.locations}) : super(key: key);
//
//   @override
//   _PlanMapViewState createState() => _PlanMapViewState();
// }
//
// class _PlanMapViewState extends State<PlanMapView> {
//   GoogleMapController? _mapController;
//   LocationData? _currentLocation;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchCurrentLocation();
//   }
//
//   Future<void> _fetchCurrentLocation() async {
//     Location location = Location();
//
//     bool serviceEnabled;
//     PermissionStatus permissionGranted;
//
//     serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) {
//         return;
//       }
//     }
//
//     permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }
//
//     final currentLocation = await location.getLocation();
//     setState(() {
//       _currentLocation = currentLocation;
//       _moveCameraToLocation(
//         LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
//       );
//     });
//   }
//
//   void _moveCameraToLocation(LatLng target) {
//     if (_mapController != null) {
//       _mapController!.animateCamera(CameraUpdate.newCameraPosition(
//         CameraPosition(target: target, zoom: 15.0),
//       ));
//     }
//   }
//
//   double _calculateDistance(LatLng point1, LatLng point2) {
//     const double earthRadius = 6371000; // in meters
//     final double lat1Rad = point1.latitude * (math.pi / 180);
//     final double lat2Rad = point2.latitude * (math.pi / 180);
//     final double deltaLat = (point2.latitude - point1.latitude) * (math.pi / 180);
//     final double deltaLng = (point2.longitude - point1.longitude) * (math.pi / 180);
//
//     final double a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
//         math.cos(lat1Rad) * math.cos(lat2Rad) *
//             math.sin(deltaLng / 2) * math.sin(deltaLng / 2);
//     final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
//
//     return earthRadius * c; // Distance in meters
//   }
//
//   double _getZoomLevel(double distance) {
//     const double scale = 2; // Adjust this scale factor as needed
//     double zoomLevel = 16 - math.log(distance / 500) / math.log(scale);
//     return zoomLevel.clamp(0, 20); // Clamp to valid zoom levels [0, 20]
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Set<Marker> markers = {};
//
//     if (widget.locations != null && widget.locations!.isNotEmpty) {
//       for (int i = 0; i < widget.locations!.length; i++) {
//         final location = widget.locations![i];
//         final GeoPoint geoPoint = location['location'] as GeoPoint;
//         final String spotName = location['spotName'] as String;
//
//         // Creating a marker using GeoPoint data
//         markers.add(
//           Marker(
//             markerId: MarkerId('marker_$i'),
//             position: LatLng(geoPoint.latitude, geoPoint.longitude),
//             infoWindow: InfoWindow(title: '$spotName (#${i + 1})'),
//             flat: true, // marker remains flat on the map
//           ),
//         );
//       }
//     }
//
//     if (widget.locations == null || widget.locations!.isEmpty) {
//       if (_currentLocation != null) {
//         markers.add(
//           Marker(
//             markerId: const MarkerId("current"),
//             position: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
//             infoWindow: InfoWindow(title: "Your Location"),
//             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//           ),
//         );
//       }
//     }
//
//     print('Number of markers: ${markers.length}');
//
//     LatLngBounds? bounds;
//     if (markers.isNotEmpty) {
//       var markerPositions = markers.map((m) => m.position).toList();
//
//       if (markerPositions.length == 1) {
//         // Single marker: adjust to a predefined zoom level
//         final singleMarkerPosition = markerPositions[0];
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           _mapController?.animateCamera(
//             CameraUpdate.newCameraPosition(
//               CameraPosition(target: singleMarkerPosition, zoom: 15.0), // Set zoom level for single location
//             ),
//           );
//         });
//       } else {
//         // Multiple markers: calculate bounds and adjust zoom level based on distance
//         bounds = LatLngBounds(
//           southwest: LatLng(
//             markerPositions.map((m) => m.latitude).reduce((a, b) => a < b ? a : b),
//             markerPositions.map((m) => m.longitude).reduce((a, b) => a < b ? a : b),
//           ),
//           northeast: LatLng(
//             markerPositions.map((m) => m.latitude).reduce((a, b) => a > b ? a : b),
//             markerPositions.map((m) => m.longitude).reduce((a, b) => a > b ? a : b),
//           ),
//         );
//
//         // Calculate the distance between southwest and northeast corners
//         final double diagonalDistance = _calculateDistance(bounds.southwest, bounds.northeast);
//
//         // Determine the appropriate zoom level based on this distance
//         final double zoomLevel = _getZoomLevel(diagonalDistance);
//
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           // _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds!, 50.0));
//           // _mapController?.animateCamera(CameraUpdate.zoomTo(zoomLevel)); // Set zoom level based on the distance
//
//           // Animate to the first marker location after removing a location
//           _mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(
//             widget.locations!.first['location'].latitude,
//             widget.locations!.first['location'].longitude,
//           )));
//
//           // Adjust the zoom level based on the remaining markers
//           _mapController?.animateCamera(CameraUpdate.zoomTo(zoomLevel));
//         });
//       }
//     }
//
//     return Stack(
//       children: [
//         GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target: widget.locations != null && widget.locations!.isNotEmpty
//                 ? LatLng(
//               widget.locations!.first['location'].latitude,
//               widget.locations!.first['location'].longitude,
//             )
//                 : const LatLng(0, 0),
//             zoom: 15.0,
//           ),
//           markers: markers,
//           onMapCreated: (GoogleMapController controller) {
//             _mapController = controller;
//             if (bounds != null && markers.length > 1) {
//               _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0)); // Adjust the zoom level
//             }
//           },
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;

class PlanMapView extends StatefulWidget {
  final List<Map<String, dynamic>>? locations; // List of locations with their spot data

  const PlanMapView({Key? key, this.locations}) : super(key: key);

  @override
  _PlanMapViewState createState() => _PlanMapViewState();
}

class _PlanMapViewState extends State<PlanMapView> {
  GoogleMapController? _mapController;
  LocationData? _currentLocation;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

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

  double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000; // in meters
    final double lat1Rad = point1.latitude * (math.pi / 180);
    final double lat2Rad = point2.latitude * (math.pi / 180);
    final double deltaLat = (point2.latitude - point1.latitude) * (math.pi / 180);
    final double deltaLng = (point2.longitude - point1.longitude) * (math.pi / 180);

    final double a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(lat1Rad) * math.cos(lat2Rad) *
            math.sin(deltaLng / 2) * math.sin(deltaLng / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c; // Distance in meters
  }

  double _getZoomLevel(double distance) {
    const double scale = 2; // Adjust this scale factor as needed
    double zoomLevel = 16 - math.log(distance / 500) / math.log(scale);
    return zoomLevel.clamp(0, 20); // Clamp to valid zoom levels [0, 20]
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {};

    if (widget.locations != null && widget.locations!.isNotEmpty) {
      for (int i = 0; i < widget.locations!.length; i++) {
        final location = widget.locations![i];
        final GeoPoint geoPoint = location['location'] as GeoPoint;
        final String spotName = location['spotName'] as String;

        // Creating a marker using GeoPoint data
        markers.add(
          Marker(
            markerId: MarkerId('marker_$i'),
            position: LatLng(geoPoint.latitude, geoPoint.longitude),
            infoWindow: InfoWindow(title: '$spotName (#${i + 1})'),
            flat: true, // marker remains flat on the map
          ),
        );
      }
    }

    if (widget.locations == null || widget.locations!.isEmpty) {
      if (_currentLocation != null) {
        markers.add(
          Marker(
            markerId: const MarkerId("current"),
            position: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
            infoWindow: InfoWindow(title: "Your Location"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        );
      }
    }

    print('Number of markers: ${markers.length}');

    LatLngBounds? bounds;
    if (markers.isNotEmpty) {
      var markerPositions = markers.map((m) => m.position).toList();

      if (markerPositions.length == 1) {
        // Single marker: adjust to a predefined zoom level
        final singleMarkerPosition = markerPositions[0];
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _mapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: singleMarkerPosition, zoom: 15.0), // Set zoom level for single location
            ),
          );
        });
      } else {
        // Multiple markers: calculate bounds and adjust zoom level based on distance
        bounds = LatLngBounds(
          southwest: LatLng(
            markerPositions.map((m) => m.latitude).reduce((a, b) => a < b ? a : b),
            markerPositions.map((m) => m.longitude).reduce((a, b) => a < b ? a : b),
          ),
          northeast: LatLng(
            markerPositions.map((m) => m.latitude).reduce((a, b) => a > b ? a : b),
            markerPositions.map((m) => m.longitude).reduce((a, b) => a > b ? a : b),
          ),
        );

        // Calculate the distance between southwest and northeast corners
        final double diagonalDistance = _calculateDistance(bounds.southwest, bounds.northeast);

        // Determine the appropriate zoom level based on this distance
        final double zoomLevel = _getZoomLevel(diagonalDistance);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds!, 80.0));
        });
      }
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: widget.locations != null && widget.locations!.isNotEmpty
                ? LatLng(
              widget.locations!.first['location'].latitude,
              widget.locations!.first['location'].longitude,
            )
                : const LatLng(0, 0),
            zoom: 15.0,
          ),
          markers: markers,
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
            if (bounds != null && markers.length > 1) {
              _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds!, 80.0)); // Adjust the zoom level
            } else if (widget.locations != null && widget.locations!.isNotEmpty) {
              // Move camera to the first marker
              _mapController?.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(
                      widget.locations!.first['location'].latitude,
                      widget.locations!.first['location'].longitude,
                    ),
                    zoom: 15.0,
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}