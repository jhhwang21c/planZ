import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapView extends StatefulWidget {
  final GeoPoint? spotLocation;

  const MapView({Key? key, this.spotLocation}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  LocationData? currentLocation;

  @override
  void initState() {
    super.initState();
    if (widget.spotLocation == null) {
      getCurrentLocation();
    }
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
    return (widget.spotLocation == null && currentLocation == null)
        ? const Center(child: Text("Loading location"))
        : GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.spotLocation != null
            ? LatLng(widget.spotLocation!.latitude, widget.spotLocation!.longitude)
            : LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        zoom: 15.0,
      ),
      markers: {
        if (widget.spotLocation != null)
          Marker(
            markerId: const MarkerId("spot"),
            position: LatLng(widget.spotLocation!.latitude, widget.spotLocation!.longitude),
          ),
        if (currentLocation != null)
          Marker(
            markerId: const MarkerId("current"),
            position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          ),
      },
    );
  }
}