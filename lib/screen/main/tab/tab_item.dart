import 'package:planZ/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:planZ/screen/main/tab/browse/f_browse.dart';
import 'package:planZ/screen/main/tab/feed/f_feed.dart';
import 'package:planZ/screen/main/tab/mypage/f_mypage.dart';
import 'package:planZ/screen/main/tab/plan/f_plan.dart';
import 'package:planZ/screen/main/tab/settings/f_settings.dart';

enum TabItem {
  feed("assets/image/icon/Feed.svg", 'Feed'),
  browse("assets/image/icon/Browse.svg", 'Browse'),
  plan("assets/image/icon/Plan.svg", 'Plan'),
  mypage("assets/image/icon/Mypage.svg", 'My Page'),
  settings("assets/image/icon/Setting.svg", 'Settings');

  final String iconPath;
  final String tabName;

  const TabItem(this.iconPath, this.tabName);

  Widget firstPage(AbstractThemeColors themeColors) {
    switch (this) {
      case TabItem.feed:
        return FeedFragment(themeColors: themeColors);
      case TabItem.browse:
        return BrowseFragment(themeColors: themeColors,);
      case TabItem.plan:
        return PlanFragment(themeColors: themeColors);
      case TabItem.mypage:
        return MyPageFragment(themeColors: themeColors);
      case TabItem.settings:
        return SettingsFragment(themeColors: themeColors);
    }
  }

  BottomNavigationBarItem toNavigationBarItem(BuildContext context, {required bool isActivated}) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        key: ValueKey(tabName),
        color: isActivated ? context.appColors.iconButton : context.appColors.iconButtonInactivate,
      ),
      label: tabName,
    );
  }
}
