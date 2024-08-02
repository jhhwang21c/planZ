import 'package:flutter/material.dart';
import 'package:planZ/common/common.dart';

class SettingsFragment extends StatefulWidget {
  final AbstractThemeColors themeColors;
  const SettingsFragment({super.key, required this.themeColors});

  @override
  State<SettingsFragment> createState() => _SettingsFragmentState();
}

class _SettingsFragmentState extends State<SettingsFragment> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("settings", style: TextStyle(fontSize: 30),));
  }
}
