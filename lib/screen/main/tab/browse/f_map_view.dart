import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

// List places = [
//   {'id': 0, 'name': 'Place 1', 'price': 0.0},
//   {'id': 1, 'name': 'Place 2', 'price': 10.0},
//   {'id': 2, 'name': 'Place 3', 'price': 20.0},
//   {'id': 3, 'name': 'Place 4', 'price': 30.0},
//   {'id': 4, 'name': 'Place 5', 'price': 40.0},
// ];

class MapView extends StatefulWidget {
  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final locationController = Location();
  GoogleMapController? mapController;

  static const googlePlex = LatLng(37.4223, -122.0848);

  LatLng? currentPosition;
  Marker? currentLocationMarker;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await fetchLocationUpdates());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: googlePlex, zoom: 13),
          markers:
              currentLocationMarker != null ? {currentLocationMarker!} : {},
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
            if (currentPosition != null) {
              mapController!.animateCamera(
                CameraUpdate.newLatLng(currentPosition!),
              );
            }
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
            })
      ],
    );
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
    } if (!serviceEnabled) {
      return;
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
    }
    if (permissionGranted != PermissionStatus.granted) {
      return;
    }

    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPosition = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
          currentLocationMarker = Marker(
            markerId: MarkerId('currentLocation'),
            position: currentPosition!,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          );
          mapController
              ?.animateCamera(CameraUpdate.newLatLng(currentPosition!));
        });
      }
    });
    print(currentPosition!);
  }
}
