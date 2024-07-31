import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../../common/common.dart';

class MapView extends StatefulWidget {
  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final Completer<GoogleMapController> _controller = Completer();

  static const sourceLocation = LatLng(37.4223, -122.0848);
  static const destination = LatLng(37.33429383, -122.06600055);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition:
              CameraPosition(target: sourceLocation, zoom: 13.5),
          markers: {
            Marker(
              markerId: MarkerId("source"),
              position: sourceLocation,
            ),
            Marker(
              markerId: MarkerId("destination"),
              position: destination,
            )
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
}
