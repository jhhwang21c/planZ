import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planZ/common/common.dart';
import 'package:planZ/common/widget/w_searchbar.dart';
import 'package:planZ/common/widget/w_togglebar.dart';
import 'package:planZ/screen/main/tab/browse/f_fullvideo.dart';
import 'package:planZ/screen/main/tab/browse/f_map_view.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class BrowseFragment extends StatefulWidget {
  const BrowseFragment({super.key,});

  @override
  State<BrowseFragment> createState() => _BrowseFragmentState();
}

class _BrowseFragmentState extends State<BrowseFragment>
    with TickerProviderStateMixin {
  List<String> labels = ['Browse', 'Map'];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TabController _tabController;
  late PageController _pageController;

  // @override
  // void initState() {
  //   super.initState();
  //   _tabController = TabController(length: labels.length, vsync: this);
  //   _pageController = PageController();
  // }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  Future<List<Map<String, dynamic>>> _fetchVideos() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('video')
        .orderBy('num_likes', descending: true)
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
        // code for Android
        thumbnailPath = await VideoThumbnail.thumbnailFile(
          video: videoUrl,
          thumbnailPath: tempPath,
          imageFormat: ImageFormat.PNG,
          maxWidth: 128,
          quality: 25,
        );
      } else if (Platform.isIOS) {
        // code for iOS
        thumbnailPath = await VideoThumbnail.thumbnailFile(
          video: videoUrl,
          thumbnailPath: tempPath,
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
  void dispose() {
    _tabController.dispose();
    // _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Browse Tab
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _fetchVideos(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('No videos found'));
                          }
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
                                      Navigator.push(context,
                                        MaterialPageRoute(
                                          builder: (context) => FullVideo(
                                            videos: videos,
                                            initialIndex: index,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(1),
                                      child: AspectRatio(
                                        aspectRatio: 9 / 16,
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          color: Colors.blue,
                                          child: thumbnailPath.isEmpty
                                              ? const Center(child: Text('No Thumbnail'))
                                              : Image.file(File(thumbnailPath),
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
                        },
                      ),

                      // Map Tab
                      Stack(children: [
                        MapView(),
                        // DraggableScrollableSheet(
                        //   initialChildSize: 0.1,
                        //   minChildSize: 0.1,
                        //   maxChildSize: 1,
                        //   builder: (BuildContext context, ScrollController scrollController) {
                        //     return Container(color: Colors.blue,);
                        //   },
                        // ),
                      ]),
                    ],
                  ),
                ),

                // Centered Tab Bar
                Positioned(
                  top: 74,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ToggleBarWidget(
                        labels: labels,
                        tabController: _tabController,
                      ),
                    ),
                  ),
                ),
                SearchBarWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}