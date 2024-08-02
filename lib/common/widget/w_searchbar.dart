import 'package:flutter/material.dart';
import 'package:planZ/common/common.dart';

class SearchBarWidget extends StatelessWidget {
  final AbstractThemeColors themeColors;
  const SearchBarWidget({super.key, required this.themeColors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        padding: const EdgeInsets.only(top: 12.0),
        height: 60.0,
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100.0),
              borderSide: const BorderSide(width: 0.8),
            ),
            prefixIcon: const Icon(
              Icons.search,
              size: 24.0,
            ),
          ),
        ),
      ),
    );
  }
}
