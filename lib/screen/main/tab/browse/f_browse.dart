import 'package:flutter/material.dart';
import 'package:planZ/screen/main/tab/browse/f_map_view.dart';
import 'package:planZ/screen/main/tab/browse/f_browse_view.dart';

class BrowseFragment extends StatefulWidget {
  const BrowseFragment({super.key});

  @override
  State<BrowseFragment> createState() => _BrowseFragmentState();
}

class _BrowseFragmentState extends State<BrowseFragment> with SingleTickerProviderStateMixin {
  List<String> labels = ['Browse', 'Map'];
  late PageController _pageController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabController = TabController(length: labels.length, vsync: this);
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
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          height: 64.0,
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(width: 0.8),
              ),
              prefixIcon: const Icon(
                Icons.search,
                size: 20.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: Stack(children: [
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                BrowseView(),
                MapView(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 67.0, vertical: 10.0),
              child: Container(
                height: 28.0,
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: TabBar(
                  controller: _tabController,
                  onTap: _onTabTapped,
                  tabs: labels.map((label) {
                    return SizedBox(
                      width: 160.0,
                      child: Tab(text: label),
                    );
                  }).toList(),
                  indicator: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  labelStyle: const TextStyle(fontWeight: FontWeight.normal),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}