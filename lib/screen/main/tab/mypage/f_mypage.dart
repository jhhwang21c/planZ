import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:planZ/common/common.dart';
import 'package:planZ/common/widget/w_floating_menu.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../browse/f_fullvideo.dart';

class MyPageFragment extends StatefulWidget {

  MyPageFragment({super.key,});

  @override
  State<MyPageFragment> createState() => _MyPageFragmentState();
}

class _MyPageFragmentState extends State<MyPageFragment>
    with TickerProviderStateMixin {
  List<String> labels = ['Journeys', 'Zips'];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? _user;

  late TabController _tabController;
  late PageController _pageController;

  Future<void> _fetchUserData(String userId) async {
    DocumentSnapshot userSnapshot =
        await _firestore.collection('user').doc(userId).get();
    setState(() {
      _user = userSnapshot.data() as Map<String, dynamic>?;
    });
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

  Future<List<Map<String, dynamic>>> _fetchUserVideos() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('video')
        .where('user_id', isEqualTo: currentUser.uid)
        .get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<String> _generateThumbnail(String videoUrl) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;
      String? thumbnailPath;

      if (Platform.isAndroid) {
        // Original code for Android
        thumbnailPath = await VideoThumbnail.thumbnailFile(
          video: videoUrl,
          thumbnailPath: tempPath,
          // Save to temp directory
          imageFormat: ImageFormat.PNG,
          maxWidth: 128,
          quality: 25,
        );
      } else if (Platform.isIOS) {
        // New code for iOS
        thumbnailPath = await VideoThumbnail.thumbnailFile(
          video: videoUrl,
          thumbnailPath: tempPath,
          // Save to temp directory
          imageFormat: ImageFormat.PNG,
          maxWidth: 128,
          quality: 25,
        );

        if (thumbnailPath != null) {
          final decodedPath = Uri.decodeFull(thumbnailPath);
          if (File(decodedPath).existsSync()) {
            print('Thumbnail file exists at: $decodedPath');
            return decodedPath;
          } else {
            print('Thumbnail file does not exist at: $decodedPath');
            return '';
          }
        } else {
          return '';
        }
      }

      return thumbnailPath ?? '';
    } catch (e) {
      print('Error generating thumbnail: $e');
      return '';
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabController = TabController(length: labels.length, vsync: this);
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _fetchUserData(currentUser.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //user info
        if (_user == null)
          const Center(child: CircularProgressIndicator())
        else
        Padding(
          padding: EdgeInsets.only(left: 24.0, top: 12.0, bottom: 18.0),
          child: Row(
            children: [
              //user profile
              Container(
                width: 88.0,
                height: 88.0,
                child: Stack(children: [
                  CircleAvatar(
                    backgroundColor:
                        _user!['profile_img_link'] == null ? Colors.grey : null,
                    backgroundImage: _user!['profile_img_link'] != null
                        ? NetworkImage(_user!['profile_img_link'])
                        : null,
                    radius: 44.0,
                  ),
                  Positioned(
                      right: 5,
                      bottom: 0,
                      child: SvgPicture.asset(
                        'assets/image/icon/Badge.svg',
                        width: 19.36,
                        height: 19.36,
                      ))
                ]),
              ),
              SizedBox(
                width: 24.0,
              ),

              //username
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _user!['username'] ?? 'Unknown',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text('🇰🇷')
                    ],
                  ),

                  //edit profile
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Container(
                      width: 62,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: context.appColors.mainGray,
                      ),
                      child: Center(
                        child: Text(
                          "Edit profile",
                          style: TextStyle(
                              color: context.appColors.mainWhite,
                              fontSize: 10,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),

                  //following
                  SizedBox(
                    width: 108.0,
                    height: 24.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Following",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "${_user!['following']?.length ?? 0}",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),

                  //followers
                  SizedBox(
                    width: 108.0,
                    height: 24.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Follower",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "${_user!['followers']?.length ?? 0}",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),

        //toggle bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: TabBar(
            controller: _tabController,
            onTap: _onTabTapped,
            tabs: labels.map((label) {
              return SizedBox(
                width: 160.0,
                child: Tab(text: label),
              );
            }).toList(),
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                color: context.appColors.mainBlack,
                width: 2.0,
              ),
            ),
            indicatorColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: context.appColors.mainBlack,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            unselectedLabelColor: context.appColors.mainGray,
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ),

        //TabBarView with grid
        Expanded(
            child: Stack(children: [
          TabBarView(
            controller: _tabController,
            children: [
              //Zips Tab
              Center(
                child: Text("Journeys Content"),
              ),
              //Journeys Tab
              FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchUserVideos(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No Videos Found'));
                    } else {
                      var videos = snapshot.data!;

                      return GridView.builder(
                        itemCount: videos.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 9 / 16,
                        ),
                        itemBuilder: (context, index) {
                          var video = videos[index];
                          return FutureBuilder<String>(
                            future: _generateThumbnail(video['video_link']),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text('Error generating thumbnail'));
                              }
                              var thumbnailPath = snapshot.data!;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FullVideo(
                                        videos: videos,
                                        initialIndex: index,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3.0, vertical: 3.0),
                                  child: AspectRatio(
                                    aspectRatio: 9 / 16,
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      color: Colors.blue,
                                      child: thumbnailPath.isEmpty
                                          ? const Center(
                                              child: Text('No Thumbnail'))
                                          : Image.file(
                                              File(thumbnailPath),
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                  }),
            ],
          ),
          Positioned(
            right: 24,
              bottom: 24,
              child: FloatingMenu(
            onPressed: () {},
            buttons: [
              PopupMenuItem(value: 'Journey', child: Text('Journey')),
              PopupMenuItem(value: 'Zip', child: Text('Zip'))
            ],
          ))
        ]))
      ],
    );
  }
}
