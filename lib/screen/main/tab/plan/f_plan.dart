import 'package:flutter/material.dart';

class PlanFragment extends StatefulWidget {
  const PlanFragment({super.key});

  @override
  State<PlanFragment> createState() => _PlanFragmentState();
}

class _PlanFragmentState extends State<PlanFragment> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("plan", style: TextStyle(fontSize: 30),));
  }
}

