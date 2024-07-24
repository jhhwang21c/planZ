import 'package:flutter/material.dart';

class BrowseFragment extends StatefulWidget {
  const BrowseFragment({super.key});

  @override
  State<BrowseFragment> createState() => _BrowseFragmentState();
}

class _BrowseFragmentState extends State<BrowseFragment> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("browse", style: TextStyle(fontSize: 30),));
  }
}
