import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

List places = [
  {'id': 0, 'name': 'Place 1', 'price': 0.0},
  {'id': 1, 'name': 'Place 2', 'price': 10.0},
  {'id': 2, 'name': 'Place 3', 'price': 20.0},
  {'id': 3, 'name': 'Place 4', 'price': 30.0},
  {'id': 4, 'name': 'Place 5', 'price': 40.0},
];

class MapView extends StatelessWidget {
  static const googlePlex = LatLng(37.4223, -122.0848);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
            initialCameraPosition:
                CameraPosition(target: googlePlex, zoom: 13),
        markers: {
              const Marker(
                markerId: MarkerId('sourceLocation'),
                icon: BitmapDescriptor.defaultMarker,
                position: googlePlex
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
