import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planZ/app_state.dart';
import 'package:planZ/common/common.dart';
import 'package:planZ/common/dart/extension/context_extension.dart';
import 'package:planZ/screen/main/tab/browse/f_map_view.dart';
import 'package:planZ/screen/main/tab/feed/f_spot_detail.dart';
import 'package:planZ/screen/main/tab/mypage/f_userinfo.dart';
import 'package:video_player/video_player.dart';
import 'package:planZ/common/widget/w_togglebar.dart';

class FullVideo extends StatefulWidget {
  final List<Map<String, dynamic>> videos;
  final int initialIndex;

  const FullVideo(
      {super.key, required this.videos, required this.initialIndex});

  @override
  State<FullVideo> createState() => _FullVideoState();
}

class _FullVideoState extends State<FullVideo>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TabController _tabController;
  late PageController _videoPageController;
  late VideoPlayerController _videoPlayerController;
  late int _currentVideoIndex;
  Map<String, dynamic>? _user;
  Map<String, dynamic>? _spot;
  GeoPoint? _spotLocation;
  String currentLanguage = AppLangState.instance.appLanguage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _videoPageController = PageController(initialPage: widget.initialIndex);
    _currentVideoIndex = widget.initialIndex;

    // Initialize the video player controller
    _initializeVideo(widget.videos[_currentVideoIndex]['video_link']);
    _fetchData(widget.videos[_currentVideoIndex]);

    _tabController.addListener(() {
      setState(() {});
    });
  }

  void _initializeVideo(String videoUrl) {
    _videoPlayerController = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        setState(() {
          _videoPlayerController.play();
        });
      });
  }

  void _onVideoPageChanged(int index) {
    setState(() {
      _currentVideoIndex = index;
      _videoPlayerController.dispose(); // Dispose of the old video controller
      _initializeVideo(widget.videos[_currentVideoIndex]
          ['video_link']); // Initialize the new video
      _fetchData(widget.videos[
          _currentVideoIndex]); // Fetch user and spot data for the new video
    });
  }

  Future<void> _fetchData(Map<String, dynamic> video) async {
    await _fetchUserData(video['user_id']);
    await _fetchSpotData(video['spot_id']);
  }

  Future<void> _fetchUserData(String userId) async {
    DocumentSnapshot userSnapshot =
        await _firestore.collection('user').doc(userId).get();
    setState(() {
      _user = userSnapshot.data() as Map<String, dynamic>?;
    });
  }

  Future<void> _fetchSpotData(String spotId) async {
    DocumentSnapshot spotSnapshot =
        await _firestore.collection('spot').doc(spotId).get();

    if (spotSnapshot.exists) {
      var spotData = spotSnapshot.data() as Map<String, dynamic>;

      setState(() {
        _spot = spotData;
        _spotLocation = _spot?['location'];
      });
    } else {
      setState(() {
        _spotLocation = null;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _videoPageController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> labels = ["Video", "Map"];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              TabBarView(
                controller: _tabController,
                children: [
                  // Video tab with vertical scrolling
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _videoPlayerController.value.size.width,
                        height: _videoPlayerController.value.size.height,
                        child: VideoTab(
                          videos: widget.videos,
                          currentVideoIndex: _currentVideoIndex,
                          videoPlayerController: _videoPlayerController,
                          onPageChanged: _onVideoPageChanged,
                          videoPageController: _videoPageController,
                        ),
                      ),
                    ),
                  ),

                  // Map view tab
                  Center(
                    child: _spotLocation != null
                        ? MapView(spotLocation: _spotLocation!)
                        : Text('No location available'),
                  ),
                ],
              ),

              // Tab bar
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: ToggleBarWidget(
                  labels: labels,
                  tabController: _tabController,
                ),
              ),
              IconButton(
                color: context.appColors.mainBlack,
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(
                      context, true); // Navigate back to the previous page
                },
              ),

              //bottom part
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [context.appColors.mainBlack, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [0, 0.6],
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 20, left: 24, right: 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserInfo(
                                  profileImageUrl: _user!['profile_img_link'],
                                  username: _user!['username'],
                                  followersCount: _user!['follower']?.length ??
                                      "no followers",
                                  followingCount: _user!['following']?.length ??
                                      "no following",
                                  userId: widget.videos[_currentVideoIndex]['user_id'],
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              if (_user != null &&
                                  _user!['profile_img_link'] != null)
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(_user!['profile_img_link']),
                                  radius: 16.0,
                                ),
                              const SizedBox(width: 10.0),
                              Text(
                                _user != null
                                    ? _user!['username'] ?? 'Unknown User'
                                    : 'Loading',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SpotDetail(
                                        spotItem: _spot ?? {},
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 26.0,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 6.0),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/image/icon/Location.svg',
                                            width: 8.0,
                                            height: 10.0,
                                          ),
                                          const SizedBox(width: 4.0),
                                          Text(
                                            _spot != null
                                                ? _spot!['translated_name']
                                                        [currentLanguage] ??
                                                    'No Info'
                                                : 'Loading',
                                            style: TextStyle(
                                              fontSize: 10.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _spot != null
                              ? _spot!['translated_short_description']
                                      [currentLanguage] ??
                                  'Unknown Description'
                              : 'Loading',
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 24,
                bottom: 27,
                child: Column(
                  children: [
                    SvgPicture.asset('assets/image/icon/Like.svg'),
                    const SizedBox(
                      height: 20,
                    ),
                    SvgPicture.asset(
                      'assets/image/icon/Save.svg',
                      color: context.appColors.mainWhite,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Icon(
                      Icons.share,
                      color: context.appColors.mainWhite,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Icon(Icons.add, color: context.appColors.mainWhite)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class VideoTab extends StatefulWidget {
  final List<Map<String, dynamic>> videos;
  final int currentVideoIndex;
  final VideoPlayerController videoPlayerController;
  final void Function(int) onPageChanged;
  final PageController videoPageController;

  const VideoTab({
    required this.videos,
    required this.currentVideoIndex,
    required this.videoPlayerController,
    required this.onPageChanged,
    required this.videoPageController,
    Key? key,
  }) : super(key: key);

  @override
  _VideoTabState createState() => _VideoTabState();
}

class _VideoTabState extends State<VideoTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PageView.builder(
      scrollDirection: Axis.vertical,
      controller: widget.videoPageController,
      itemCount: widget.videos.length,
      onPageChanged: widget.onPageChanged,
      itemBuilder: (context, index) {
        if (index == widget.currentVideoIndex) {
          return Center(
            child: widget.videoPlayerController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: widget.videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(widget.videoPlayerController),
                  )
                : CircularProgressIndicator(),
          );
        } else {
          // Placeholder for non-visible videos, could be a thumbnail or a loading indicator
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
