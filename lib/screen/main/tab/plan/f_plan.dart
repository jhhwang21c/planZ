import 'package:flutter/material.dart';
import 'package:planZ/common/common.dart';

class PlanFragment extends StatefulWidget {
  final AbstractThemeColors themeColors;
  const PlanFragment({super.key, required this.themeColors});

  @override
  State<PlanFragment> createState() => _PlanFragmentState();
}

class _PlanFragmentState extends State<PlanFragment> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("plan", style: TextStyle(fontSize: 30),));
  }
}

