import 'package:flutter/material.dart';
import 'package:planZ/common/widget/w_togglebar.dart';

class MySaves extends StatefulWidget {
  const MySaves({super.key});

  @override
  State<MySaves> createState() => _MySavesState();
}

class _MySavesState extends State<MySaves> with SingleTickerProviderStateMixin{
  @override
  List<String> labels = ['Spots', 'Journeys'];
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

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: SizedBox(
              height: 24,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context); // Navigate back to the previous page
                    },
                  ),
                ],
              ),
            ),
          ),

          //Toggle Bar
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: ToggleBarWidget(labels: labels, tabController: _tabController, pageController: _pageController),
          )

          //Spots
        ],
      ),
    );
  }
}
