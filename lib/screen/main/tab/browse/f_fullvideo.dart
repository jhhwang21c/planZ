import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FullVideo extends StatefulWidget {
  final Map<String, dynamic> video;

  const FullVideo({super.key, required this.video});

  @override
  _FullVideoState createState() => _FullVideoState();
}

class _FullVideoState extends State<FullVideo> with SingleTickerProviderStateMixin{
  List<String> labels = ['Browse', 'Map'];
  late VideoPlayerController _controller;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? _user;

  late PageController _pageController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabController = TabController(length: labels.length, vsync: this);
  }

  Future<void> _initialize() async {
    await _fetchUserData(widget.video['user_id']);
    _controller = VideoPlayerController.network(widget.video['video_link']);
    await _controller.initialize();
    _controller.play();
  }

  Future<void> _fetchUserData(String userId) async {
    DocumentSnapshot userSnapshot =
    await _firestore.collection('user').doc(userId).get();

    _user = userSnapshot.data() as Map<String, dynamic>?;
    print(_user);
  }

  @override
  void dispose() {
    _controller.dispose();
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
      body: DefaultTabController(
        length: labels.length,
        child: FutureBuilder<void>(
          future: _initialize(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return Stack(
              children: [
                // Video
                _controller.value.isInitialized
                    ? Center(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                )
                    : const CircularProgressIndicator(),

                // Tab Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 67.0, vertical: 12.0),
                  child: Container(
                    height: 28.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[350],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: TabBar(
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

                // Info
                Padding(
                  padding: EdgeInsets.only(top: 500.0, left: 24.0, right: 56.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _user != null
                                ? _user!['username'] ?? 'Unknown User'
                                : 'Loading',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0, // Adjust font size as needed
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '@Location',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0, // Adjust font size as needed
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '@Spot Name',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0, // Adjust font size as needed
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '@View Journey',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0, // Adjust font size as needed
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '#Hashtag',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                          ),
                          Text(
                            '#Hashtag',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'We all have both light and dark inside us, but what matters is what we choose to act on. ',
                        style: TextStyle(color: Colors.white, fontSize: 10.0),
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}