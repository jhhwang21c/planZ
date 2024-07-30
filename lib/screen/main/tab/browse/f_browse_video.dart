import 'package:flutter/material.dart';

class BrowseVideo extends StatelessWidget {
  final String video;

  const BrowseVideo({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(video),
      ),
      body: Center(
        child: Text('Details for $video'),
      ),
    );
  }
}