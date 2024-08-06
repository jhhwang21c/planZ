import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:planZ/common/dart/extension/context_extension.dart';

class FloatingMenu extends StatelessWidget {
  final VoidCallback onPressed;
  final List<PopupMenuItem<String>> buttons;

  const FloatingMenu(
      {super.key, required this.onPressed, required this.buttons});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: context.appColors.mainWhite,
      child: PopupMenuButton(
        icon: SvgPicture.asset(
          'assets/image/icon/add_notes.svg',
          width:30,
          height:30,),
        onSelected: (String result) {
          print(result);
        },
        itemBuilder: (BuildContext context) => buttons,
      ),
    );
  }
}
