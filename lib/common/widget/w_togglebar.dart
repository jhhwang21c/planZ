import 'package:flutter/material.dart';

import '../theme/color/abs_theme_colors.dart';

class ToggleBarWidget extends StatefulWidget {
  List<String> labels;
  TabController tabController;
  PageController pageController;
  final AbstractThemeColors themeColors;

  ToggleBarWidget({
    required this.labels,
    required this.tabController,
    required this.pageController,
    required this.themeColors,
  });

  @override
  State<ToggleBarWidget> createState() => _ToggleBarWidgetState();
}

class _ToggleBarWidgetState extends State<ToggleBarWidget> with TickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
    widget.pageController = PageController();
    widget.tabController = TabController(length: widget.labels.length, vsync: this);
  }

  @override
  void dispose() {
    widget.pageController.dispose();
    widget.tabController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    widget.pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 40.0,
          width: 242.0,// Adjust the height as needed
          decoration: BoxDecoration(
            color: widget.themeColors.grayFillQuartOp,
            borderRadius: BorderRadius.circular(100),
          ),
          child: TabBar(
            dividerColor: Colors.transparent,
            controller: widget.tabController,
            onTap: _onTabTapped,
            tabs: widget.labels.map((label) {
              return SizedBox(// Adjust the width as needed
                child: Tab(text: label),
              );
            }).toList(),

            indicator: BoxDecoration(
              color: widget.themeColors.mainBlack,
              borderRadius: BorderRadius.circular(100),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 3), // Adjust padding for the indicator
            labelColor: Colors.white,
            unselectedLabelColor: widget.themeColors.mainBlack,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700),
            unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
              fontSize: 14
            ),
          ),
        ),
      ],
    );
  }
}
