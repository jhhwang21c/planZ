import 'package:flutter/material.dart';
import 'package:planZ/screen/main/tab/feed/f_card_list.dart';
import 'package:planZ/screen/main/tab/feed/f_spot_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planZ/common/widget/w_searchbar.dart';

class FeedFragment extends StatefulWidget {
  const FeedFragment({super.key});

  @override
  State<FeedFragment> createState() => _FeedFragmentState();
}

class _FeedFragmentState extends State<FeedFragment>
    with SingleTickerProviderStateMixin {
  List<String> labels = ['Discover', 'Following'];
  final List _posts = ['post1', 'post2', 'post3', 'post4', 'post5'];

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

  Future<List<Map<String, dynamic>>> _fetchSpot() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('spot').limit(5).get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Search Bar
        SearchBarWidget(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 66.0, vertical: 30.0),
          child: Container(
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
              tabs: labels.map((label) {
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
        ),
        Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: labels.map((label) {
                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchSpot(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No Spots Found'));
                    } else {
                      var spots = snapshot.data!;


                      return ListView.builder(
                        itemCount: spots.length,
                        itemBuilder: (context, index) {
                          var spot = spots[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SpotDetail(
                                      spotName: spot['translated_name']['en'] ?? 'No Title',
                                    address: spot['translated_address']['en']?? "No Address",
                                    contact: spot['contact'] ?? "No Contact",
                                    hours: spot['hours'] ?? "Hours Unavailable",
                                      parking: spot['parking'] ?? "No Parking Info",
                                      hashtags: spot['hashtags'] ?? "No Hashtag",
                                  ),
                                ),
                              );
                            },
                            child: CardList(
                                spotTitle: spot['translated_name']['en'] ?? 'No Title',
                              shortDescription: spot['translated_short_description']['en'] ?? 'No description',
                              area: spot['area'] ?? 'No Title',
                            ),
                          );
                        },
                      );
                    }
                  },
                );
              }).toList(),
            ),
        ),
      ],
    );
  }
}
