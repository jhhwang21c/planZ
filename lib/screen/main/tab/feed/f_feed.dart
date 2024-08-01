import 'package:flutter/material.dart';
import 'package:planZ/screen/main/tab/feed/f_card_list.dart';
import 'package:planZ/screen/main/tab/feed/f_spot_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedFragment extends StatefulWidget {
  const FeedFragment({super.key});

  @override
  State<FeedFragment> createState() => _FeedFragmentState();
}

class _FeedFragmentState extends State<FeedFragment>
    with SingleTickerProviderStateMixin {
  List<String> labels = ['Discovery', 'Following'];
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          //Search Bar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
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
              child: Stack(
                children: [
                  PageView(
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
                                            spotName: spot['name'] ?? 'No Title',
                                          address: spot['address'] ?? "No Address",
                                          contact: spot['contact'] ?? "No Contact",
                                          hours: spot['hours'] ?? "Hours Unavailable",
                                            parking: spot['parking'] ?? "No Parking Info"
                                        ),
                                      ),
                                    );
                                  },
                                  child: CardList(
                                      spotTitle: spot['name'] ?? 'No Title',),
                                );
                              },
                            );
                          }
                        },
                      );
                    }).toList(),
                  ),

              //Tab Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 43.0, vertical: 10.0),
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
                    unselectedLabelStyle:
                        const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
