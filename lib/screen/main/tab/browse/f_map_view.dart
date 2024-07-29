import 'package:flutter/material.dart';

List places = [
  {'id': 0, 'name': 'Place 1', 'price': 0.0},
  {'id': 1, 'name': 'Place 2', 'price': 10.0},
  {'id': 2, 'name': 'Place 3', 'price': 20.0},
  {'id': 3, 'name': 'Place 4', 'price': 30.0},
  {'id': 4, 'name': 'Place 5', 'price': 40.0},
];

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Center(
          child: Text('MapView'),
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
