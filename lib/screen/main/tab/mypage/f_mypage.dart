import 'package:flutter/material.dart';

class MypageFragment extends StatefulWidget {
  const MypageFragment({super.key});

  @override
  State<MypageFragment> createState() => _MypageFragmentState();
}

class _MypageFragmentState extends State<MypageFragment> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("my page", style: TextStyle(fontSize: 30),));
  }
}
