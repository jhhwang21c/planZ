import 'package:flutter/material.dart';

class FeedFragment extends StatefulWidget {
  const FeedFragment({super.key});

  @override
  State<FeedFragment> createState() => _FeedFragmentState();
}

class _FeedFragmentState extends State<FeedFragment> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("feed", style: TextStyle(fontSize: 30),));
  }
}
