import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planZ/common/common.dart';

class TextFieldInpute extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final bool isPass;

  const TextFieldInpute(
      {super.key,
      required this.textEditingController,
        required this.hintText,
      this.isPass = false,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: TextField(
        obscureText: isPass,
        controller: textEditingController,
        decoration: InputDecoration(
          hintText: hintText,
          // contentPadding: EdgeInsets.symmetric(horizontal: 10),
          border: InputBorder.none,
          filled: true,
          fillColor: Color(0xFFedf0f8),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(100)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 2,
                color: Colors.blue,
              ),
              borderRadius: BorderRadius.circular(100)),
        ),
      ),
    );
  }
}
