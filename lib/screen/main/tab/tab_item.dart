import 'package:planZ/common/common.dart';
// import 'package:planZ/screen/main/tab/browse/f_browse.dart';
// import 'package:planZ/screen/main/tab/feed/f_feed.dart';
// import 'package:flutter/material.dart';
// import 'package:planZ/screen/main/tab/home/f_home.dart';
// import 'package:planZ/screen/main/tab/mypage/f_mypage.dart';
// import 'package:planZ/screen/main/tab/plan/f_plan.dart';
// import 'package:planZ/screen/main/tab/settings/f_settings.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:planZ/screen/main/tab/browse/f_browse.dart';
import 'package:planZ/screen/main/tab/feed/f_feed.dart';
import 'package:planZ/screen/main/tab/home/f_home.dart';
import 'package:planZ/screen/main/tab/mypage/f_mypage.dart';
import 'package:planZ/screen/main/tab/plan/f_plan.dart';
import 'package:planZ/screen/main/tab/settings/f_settings.dart';

enum TabItem {
  // home(Icons.home, '홈', HomeFragment()),
  // favorite(Icons.star, '즐겨찾기', FavoriteFragment(isShowBackButton: false));
  feed("assets/image/icon/Feed.svg", 'Feed', FeedFragment()),
  browse("assets/image/icon/Browse.svg", 'Browse', BrowseFragment()),
  plan("assets/image/icon/Plan.svg", 'Plan', PlanFragment()),
  mypage("assets/image/icon/Mypage.svg", 'My Page', MypageFragment()),
  settings("assets/image/icon/Setting.svg", 'Settings', SettingsFragment());

  final String iconPath;
  final String tabName;
  final Widget firstPage;

  const TabItem(this.iconPath, this.tabName, this.firstPage);

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
