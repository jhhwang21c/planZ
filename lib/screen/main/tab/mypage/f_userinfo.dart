import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:planZ/common/common.dart';
import 'package:planZ/screen/main/tab/browse/f_fullvideo_two.dart';
import 'package:video_thumbnail/video_thumbnail.dart';


class UserInfo extends StatefulWidget {
  final String? profileImageUrl;
  final String? username;
  final int followersCount;
  final int followingCount;
  final String userId;

  UserInfo({
    required this.profileImageUrl,
    required this.username,
    required this.followersCount,
    required this.followingCount,
    required this.userId,
  });

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo>
    with TickerProviderStateMixin {
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

  Future<List<Map<String, dynamic>>> _fetchUserVideos() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('video')
        .where('user_id', isEqualTo: widget.userId)
        .get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
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
          thumbnailPath: tempPath, // Save to temp directory
          imageFormat: ImageFormat.PNG,
          maxWidth: 128,
          quality: 25,
        );
      } else if (Platform.isIOS) {
        // New code for iOS
        thumbnailPath = await VideoThumbnail.thumbnailFile(
          video: videoUrl,
          thumbnailPath: tempPath, // Save to temp directory
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              color: context.appColors.mainBlack,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(
                    context, true); // Navigate back to the previous page
              },
            ),

            //user info
            Padding(
              padding: EdgeInsets.only(left: 24.0, bottom: 18.0),
              child: Row(
                children: [
                  //user profile
                  Stack(
                    children: [
                      Container(
                      width: 110.0,
                      height: 110.0,
                      child: CircleAvatar(
                        backgroundColor:
                            widget.profileImageUrl == null ? Colors.grey : null,
                        backgroundImage: widget.profileImageUrl != null
                            ? NetworkImage(widget.profileImageUrl!)
                            : null,
                        radius: 20.0,
                      ),
                    ),
                      Positioned(
                          right: 8,
                          bottom: 3,
                          child: SvgPicture.asset(
                            'assets/image/icon/Badge.svg',
                            width: 20,
                            height: 20,
                          )),
              ]
                  ),
                  SizedBox(
                    width: 24.0,
                  ),

                  //username
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${widget.username!}", style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 24
                      ),),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Container(
                          width: 44,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: context.appColors.mainBlack),
                            borderRadius: BorderRadius.circular(100),
                            color: context.appColors.mainWhite
                          ),
                          child: Center(child: Text('Follow', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),),),
                        ),
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
                //Zips Tab
                Center(
                  child: Text("Journeys Content"),
                ),
                //Journeys Tab
                FutureBuilder<List<Map<String, dynamic>>>(
                    future: _fetchUserVideos(),
                    builder: (context, snapshot)
                {
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
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 9 / 16,
                      ),
                      itemBuilder: (context, index) {
                        var video = videos[index];
                        return FutureBuilder<String>(
                          future: _generateThumbnail(video['video_link']),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text('Error generating thumbnail'));
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
                                padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
                                child: AspectRatio(
                                  aspectRatio: 9 / 16,
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    color: Colors.blue,
                                    child: thumbnailPath.isEmpty
                                        ? const Center(child: Text('No Thumbnail'))
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

                }
                ),

              ],
            ))
          ],
        ),
    );
  }
}
