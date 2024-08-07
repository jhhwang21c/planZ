import 'package:flutter/material.dart';
import 'package:planZ/common/common.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        padding: const EdgeInsets.only(top: 12.0),
        height: 60.0,
        child: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: context.appColors.mainWhite,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100.0),
              borderSide: BorderSide(
                color: context.appColors.baseGray,
                // width: 0.8,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100.0),
              borderSide: BorderSide(
                color: context.appColors.mainGray,
              ),
            ),
            prefixIcon: Icon(
              Icons.search,
              size: 24.0,
              color: context.appColors.mainGray,
            ),
          ),
        ),
      ),
    );
  }
}
