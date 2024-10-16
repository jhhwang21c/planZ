import 'package:after_layout/after_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:planZ/screen/main/s_login.dart';
import 'package:planZ/screen/main/tab/tab_item.dart';
import 'package:planZ/screen/main/tab/tab_navigator.dart';
import 'package:flutter/material.dart';

import '../../common/common.dart';

class MainScreen extends StatefulWidget {
  final AbstractThemeColors themeColors;

  const MainScreen({Key? key, required this.themeColors}) : super(key: key);

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with TickerProviderStateMixin, AfterLayoutMixin {
  TabItem _currentTab = TabItem.feed;
  final tabs = [
    TabItem.feed,
    TabItem.browse,
    TabItem.plan,
    TabItem.mypage,
    TabItem.settings
  ];
  final List<GlobalKey<NavigatorState>> navigatorKeys = [];

  int get _currentIndex => tabs.indexOf(_currentTab);

  GlobalKey<NavigatorState> get _currentTabNavigationKey =>
      navigatorKeys[_currentIndex];

  bool get extendBody => true;

  static double get bottomNavigationBarBorderRadius => 0.0;


  @override
  void initState() {
    super.initState();
    initNavigatorKeys();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: isRootPage,
      onPopInvoked: _handleBackPressed,
      child: Scaffold(
        // appBar: AppBar(title: const Center(child: Text('PlanZ')),),
        // drawer: const MenuDrawer(),
        extendBody: extendBody, //bottomNavigationBar 아래 영역 까지 그림
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: SafeArea(
              bottom: !extendBody,
              child: pages,
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(context),
      ),
    );
  }

  bool get isRootPage =>
      _currentTab == TabItem.feed &&
          _currentTabNavigationKey.currentState?.canPop() == false;

  IndexedStack get pages =>
      IndexedStack(
          index: _currentIndex,
          children: tabs
              .mapIndexed((tab, index) =>
              Offstage(
                offstage: _currentTab != tab,
                child: TabNavigator(
                  navigatorKey: navigatorKeys[index],
                  tabItem: tab,
                  themeColors: widget.themeColors,
                ),
              ))
              .toList());

  void _handleBackPressed(bool didPop) {
    if (!didPop) {
      if (_currentTabNavigationKey.currentState?.canPop() == true) {
        Nav.pop(_currentTabNavigationKey.currentContext!);
        return;
      }

      if (_currentTab != TabItem.feed) {
        _changeTab(tabs.indexOf(TabItem.feed));
      }
    }
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 1),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(bottomNavigationBarBorderRadius),
          topRight: Radius.circular(bottomNavigationBarBorderRadius),
        ),
        child: BottomNavigationBar(
          items: navigationBarItems(context),
          currentIndex: _currentIndex,
          selectedItemColor: context.appColors.text,
          unselectedItemColor: context.appColors.iconButtonInactivate,
          onTap: _handleOnTapNavigationBarItem,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: context.appColors.mainWhite,
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> navigationBarItems(BuildContext context) {
    return tabs
        .mapIndexed(
          (tab, index) =>
          tab.toNavigationBarItem(
            context,
            isActivated: _currentIndex == index,
          ),
    )
        .toList();
  }

  void _changeTab(int index) {
    setState(() {
      _currentTab = tabs[index];
    });
  }

  BottomNavigationBarItem bottomItem(bool activate, IconData iconData,
      IconData inActivateIconData, String label) {
    return BottomNavigationBarItem(
        icon: Icon(
          key: ValueKey(label),
          activate ? iconData : inActivateIconData,
          color: activate ? context.appColors.iconButton : context.appColors
              .iconButtonInactivate,
        ),
        label: label);
  }

  void _handleOnTapNavigationBarItem(int index) {
    final oldTab = _currentTab;
    final targetTab = tabs[index];
    if (oldTab == targetTab) {
      final navigationKey = _currentTabNavigationKey;
      popAllHistory(navigationKey);
    }
    _changeTab(index);
  }

  void popAllHistory(GlobalKey<NavigatorState> navigationKey) {
    final bool canPop = navigationKey.currentState?.canPop() == true;
    if (canPop) {
      while (navigationKey.currentState?.canPop() == true) {
        navigationKey.currentState!.pop();
      }
    }
  }

  void initNavigatorKeys() {
    for (final _ in tabs) {
      navigatorKeys.add(GlobalKey<NavigatorState>());
    }
  }


  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    // Check if user is logged in
    User? user = FirebaseAuth.instance.currentUser;

    // If user is not logged in, navigate to LoginPage
    if (user == null) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        FlutterNativeSplash.remove();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage(themeColors: widget.themeColors)),
        );
      });
    } else {
      FlutterNativeSplash.remove();
    }
  }
}