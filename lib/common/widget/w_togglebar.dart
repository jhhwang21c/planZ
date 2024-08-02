import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToggleBarWidget extends StatefulWidget {
  List<String> labels;

  ToggleBarWidget({
    required this.labels});

  @override
  State<ToggleBarWidget> createState() => _ToggleBarWidgetState();
}

class _ToggleBarWidgetState extends State<ToggleBarWidget> with SingleTickerProviderStateMixin{
  late PageController _pageController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabController = TabController(length: widget.labels.length, vsync: this);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    _pageController.jumpToPage(index);
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
            color: Colors.grey[350],
            borderRadius: BorderRadius.circular(100),
          ),
          child: TabBar(
            dividerColor: Colors.transparent,
            controller: _tabController,
            onTap: _onTabTapped,
            tabs: widget.labels.map((label) {
              return SizedBox(// Adjust the width as needed
                child: Tab(text: label),
              );
            }).toList(),

            indicator: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(100),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 3), // Adjust padding for the indicator
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
      ],
    );
  }
}
