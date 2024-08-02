import 'package:planZ/common/constant/app_colors.dart';
import 'package:flutter/material.dart';

export 'package:planZ/common/constant/app_colors.dart';

typedef ColorProvider = Color Function();

abstract class AbstractThemeColors {
  const AbstractThemeColors();

  Color get seedColor => const Color(0xffffffff);

  Color get veryBrightGrey => AppColors.brightGrey;

  Color get drawerBg => const Color.fromARGB(255, 255, 255, 255);

  Color get scrollableItem => const Color.fromARGB(255, 57, 57, 57);

  Color get iconButton => const Color.fromARGB(255, 0, 0, 0);

  Color get iconButtonInactivate => const Color.fromARGB(255, 162, 162, 162);

  Color get inActivate => const Color.fromARGB(255, 200, 207, 220);

  Color get activate => const Color.fromARGB(255, 63, 72, 95);

  Color get badgeBg => AppColors.blueGreen;

  Color get textBadgeText => Colors.white;

  Color get badgeBorder => Colors.transparent;

  Color get divider => const Color.fromARGB(255, 228, 228, 228);

  Color get text => AppColors.darkGrey;

  Color get hintText => AppColors.middleGrey;

  Color get focusedBorder => AppColors.darkGrey;

  Color get confirmText => AppColors.blue;

  Color get drawerText => text;

  Color get snackbarBgColor => AppColors.mediumBlue;

  Color get blueButtonBackground => AppColors.darkBlue;

  //custom
  Color get selected => const Color(0xFFEAC50C);
  Color get  logoBright=> const Color(0xFFFDDC3A);
  Color get logoPale => const Color(0xFFFFE877);
  Color get iconBackground => const Color(0xFFFFFBF0);
  Color get mainText => const Color(0xFF2A2A2A);
  Color get blackFillHalfOp => const Color(0x802A2A2A);
  Color get mainGray => const Color(0xFF5F6368);
  Color get placeholder => const Color(0xFF6F6F6F);
  Color get grayFillHalfOp => const Color(0x80ACACAC);
  Color get paleFill => const Color(0x64ACACAC);
  Color get baseGray => const Color(0xFFE6E6E6);
  Color get baseGrayPale => const Color(0x99E6E6E6);
  Color get baseWhite => const Color(0xFFFAFAFA);
}
