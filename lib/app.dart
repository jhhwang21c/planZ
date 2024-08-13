import 'package:planZ/common/common.dart';
import 'package:planZ/common/theme/custom_theme_app.dart';
import 'package:planZ/screen/main/s_main.dart';
import 'package:flutter/material.dart';

import 'common/theme/custom_theme.dart';

class App extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();


  ///light, dark 테마가 준비되었고, 시스템 테마를 따라가게 하려면 해당 필드를 제거 하시면 됩니다.
  static const defaultTheme = CustomTheme.light;
  static bool isForeground = true;

  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> with Nav, WidgetsBindingObserver {
  final AbstractThemeColors themeColors = const MyThemeColors();

  @override
  GlobalKey<NavigatorState> get navigatorKey => App.navigatorKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomThemeApp(
      child: Builder(builder: (context) {
        return MaterialApp(
          navigatorKey: App.navigatorKey,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'PlanZ', //"image finder?"
          theme: ThemeData(
            colorSchemeSeed: Colors.white,
            textTheme: Theme.of(context).textTheme.apply(
            fontFamily: 'SFProDisplay',
          ),
          ),
          home: MainScreen(themeColors: themeColors),
        );
      }),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        App.isForeground = true;
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        App.isForeground = false;
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }
}

class MyThemeColors extends AbstractThemeColors {
  const MyThemeColors();

  @override
  Color get selected => const Color(0xFFEAC50C);
  Color get logoBright=> const Color(0xFFFDDC3A);
  Color get logoPale => const Color(0xFFFFE877);
  Color get iconBackground => const Color(0xFFFFFBF0);
  Color get mainBlack => const Color(0xFF2A2A2A);
  Color get blackFillHalfOp => const Color(0x802A2A2A);
  Color get mainGray => const Color(0xFF5F6368);
  Color get placeholder => const Color(0xFF6F6F6F);
  Color get grayFillHalfOp => const Color(0x80ACACAC);
  Color get grayFillQuartOp => const Color(0x64ACACAC);
  Color get baseGray => const Color(0xFFE6E6E6);
  Color get baseGrayPale => const Color(0x99E6E6E6);
  Color get mainWhite => const Color(0xFFFAFAFA);

}
