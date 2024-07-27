import 'package:flutter/material.dart';

class CardListDetail extends StatelessWidget {
  final String title;

  CardListDetail({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('This is the detail page for $title'),
      ),
    );
  }
}
