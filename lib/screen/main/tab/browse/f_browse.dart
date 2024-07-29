import 'package:flutter/material.dart';
import 'package:planZ/common/common.dart';
import 'package:planZ/screen/main/tab/browse/f_map_view.dart';

class BrowseFragment extends StatefulWidget {
  const BrowseFragment({super.key});

  @override
  State<BrowseFragment> createState() => _BrowseFragmentState();
}

class _BrowseFragmentState extends State<BrowseFragment> {
  List<String> labels = ['Browse', 'Map'];
  final List _vids = ['vid1', 'vid2', 'vid3', 'vid4', 'vid5', 'vid6'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: labels.length,
      child: Column(
        children: [
          Container(
            padding: new EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            height: 64.0,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(width: 0.8),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 20.0,
                ),
              ),
            ),
          ),
          Expanded(
            child: Stack(children: [
              TabBarView(
                children: [
                  //Browse Tab
                  GridView.builder(
                    itemCount: _vids.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 9 / 16,
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 3.0, vertical: 3.0),
                        child: AspectRatio(
                          aspectRatio: 9 / 16,
                          child: Container(
                            height: 50,
                            width: 50,
                            color: Colors.blue,
                          ),
                        ),
                      );
                    },
                  ),
                  //Map Tab
                  MapView(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 67.0, vertical: 10.0),
                child: Container(
                  height: 28.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: TabBar(
                    tabs: labels.map((label) {
                      return Container(
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
                    labelStyle: TextStyle(fontWeight: FontWeight.normal),
                    unselectedLabelStyle:
                        TextStyle(fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
