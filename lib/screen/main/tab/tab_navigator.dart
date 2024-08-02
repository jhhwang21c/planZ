import 'package:planZ/common/common.dart';
import 'package:planZ/screen/main/tab/tab_item.dart';
import 'package:flutter/material.dart';

class TabNavigator extends StatelessWidget {
  const TabNavigator({
    Key? key,
    required this.navigatorKey,
    required this.tabItem,
    required this.themeColors,
  }) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;
  final AbstractThemeColors themeColors;

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigatorKey,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => tabItem.firstPage(themeColors),
          );
        });
  }
}
