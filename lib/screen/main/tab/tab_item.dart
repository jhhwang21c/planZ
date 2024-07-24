import 'package:planZ/common/common.dart';
import 'package:planZ/screen/main/tab/browse/f_browse.dart';
import 'package:planZ/screen/main/tab/feed/f_feed.dart';
import 'package:flutter/material.dart';
import 'package:planZ/screen/main/tab/home/f_home.dart';
import 'package:planZ/screen/main/tab/mypage/f_mypage.dart';
import 'package:planZ/screen/main/tab/plan/f_plan.dart';
import 'package:planZ/screen/main/tab/settings/f_settings.dart';

enum TabItem {
  // home(Icons.home, '홈', HomeFragment()),
  // favorite(Icons.star, '즐겨찾기', FavoriteFragment(isShowBackButton: false));
  feed(Icons.looks_one, 'Feed', FeedFragment()),
  browse(Icons.looks_two, 'Browse', BrowseFragment()),
  plan(Icons.looks_3, 'Plan', PlanFragment()),
  mypage(Icons.looks_4, 'My Page', MypageFragment()),
  settings(Icons.settings, 'Settings', SettingsFragment());

  final IconData activeIcon;
  final IconData inActiveIcon;
  final String tabName;
  final Widget firstPage;

  const TabItem(this.activeIcon, this.tabName, this.firstPage, {IconData? inActiveIcon})
      : inActiveIcon = inActiveIcon ?? activeIcon;

  BottomNavigationBarItem toNavigationBarItem(BuildContext context, {required bool isActivated}) {
    return BottomNavigationBarItem(
        icon: Icon(
          key: ValueKey(tabName),
          isActivated ? activeIcon : inActiveIcon,
          color:
              isActivated ? context.appColors.iconButton : context.appColors.iconButtonInactivate,
        ),
        label: tabName);
  }
}
