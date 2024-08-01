import 'package:flutter/material.dart';

class UserInfo extends StatefulWidget {
  final String? profileImageUrl;
  final String? username;
  final int followersCount;
  final int followingCount;

  UserInfo({
    required this.profileImageUrl,
    required this.username,
    required this.followersCount,
    required this.followingCount,
  });

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo>
    with SingleTickerProviderStateMixin {
  List<String> labels = ['Journeys', 'Zips'];

  late TabController _tabController;
  late PageController _pageController;

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
    return Scaffold(
      body: Column(
        children: [
          //user info
          Padding(
            padding: EdgeInsets.only(left: 24.0, top: 12.0, bottom: 18.0),
            child: Row(
              children: [
                //user profile
                Container(
                  width: 88.0,
                  height: 88.0,
                  child: CircleAvatar(
                    backgroundColor:
                        widget.profileImageUrl == null ? Colors.grey : null,
                    backgroundImage: widget.profileImageUrl != null
                        ? NetworkImage(widget.profileImageUrl!)
                        : null,
                    radius: 20.0,
                  ),
                ),
                SizedBox(
                  width: 24.0,
                ),

                //username
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("@${widget.username!}"),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Ranking Lv. 1"),
                    ),
                    SizedBox(
                      width: 108.0,
                      height: 24.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Following"),
                          Text("${widget.followingCount!}")
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 108.0,
                      height: 24.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Follower"),
                          Text("${widget.followersCount!}")
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),

          //toggle bar
          TabBar(
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
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            labelStyle: const TextStyle(fontWeight: FontWeight.normal),
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.normal),
          ),

          //TabBarView with grid
          Expanded(
              child: TabBarView(
            controller: _tabController,
            children: [
              //Journeys Tab
              GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.grey,
                    );
                  }),

              //Zips Tab
              Center(
                child: Text("Zips Content"),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
