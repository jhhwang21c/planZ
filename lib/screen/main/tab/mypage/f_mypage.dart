import 'package:flutter/material.dart';
import 'package:planZ/common/common.dart';

class MypageFragment extends StatefulWidget {
  final AbstractThemeColors themeColors;
  const MypageFragment({super.key, required this.themeColors});

  @override
  State<MypageFragment> createState() => _MypageFragmentState();
}

class _MypageFragmentState extends State<MypageFragment> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("my page", style: TextStyle(fontSize: 30),));
  }
}
