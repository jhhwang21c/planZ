import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planZ/screen/main/tab/browse/f_map_view.dart';
import 'package:planZ/screen/main/tab/feed/f_spot_detail.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FullVideo extends StatefulWidget {
  final List<Map<String, dynamic>> videos;
  final int initialIndex;

  const FullVideo(
      {super.key, required this.videos, required this.initialIndex});

  @override
  _FullVideoState createState() => _FullVideoState();
}

class _FullVideoState extends State<FullVideo>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late PageController _pageController;
  late List<VideoPlayerController?> _controllers;
  late TabController _tabController;
  Map<String, dynamic>? _user;
  Map<String, dynamic>? _spot;
  List<dynamic>? _hashtags;
  GeoPoint? _spotLocation;
  List<String> labels = ["Video", "Map"];
  int _currentIndex = 0;
  bool _isDisposing = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _tabController = TabController(length: labels.length, vsync: this);
    _controllers = List.generate(widget.videos.length, (index) => null);
    _currentIndex = widget.initialIndex;
    _initializeAndPlayVideo(_currentIndex);
  }

  Future<void> _initializeAndPlayVideo(int index) async {
    if (_controllers[index] == null) {
      _controllers[index] =
          VideoPlayerController.network(widget.videos[index]['video_link']);
      await _controllers[index]!.initialize();
    }

    if (mounted) {
      setState(() {
        _controllers[index]!.play();
      });

      await _fetchData(widget.videos[index]);

      // Pause and dispose controllers for videos not in the current view or adjacent views
      _disposeControllersOutsideRange(index);
    }
  }

  void _disposeControllersOutsideRange(int index) {
    for (int i = 0; i < _controllers.length; i++) {
      if (i < index - 1 || i > index + 1) {
        if (_controllers[i] != null) {
          _controllers[i]!.dispose();
          _controllers[i] = null;
        }
      }
    }
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
    setState(() {
      _spot = spotSnapshot.data() as Map<String, dynamic>?;
      _hashtags = _spot?['hashtags'] as List<dynamic>?;
      _spotLocation = _spot?['location'];
    });
  }

  void _onTabTapped(int index) {
    _tabController.animateTo(index);
    if (index == 1 && _controllers[_currentIndex] != null) {
      _controllers[_currentIndex]!.pause();
    } else if (index == 0 && _controllers[_currentIndex] != null) {
      _controllers[_currentIndex]!.play();
    }
  }

  @override
  void dispose() {
    _isDisposing = true;
    _pageController.dispose();
    _tabController.dispose();
    for (var controller in _controllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: labels.length,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              TabBarView(
                controller: _tabController,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    onPageChanged: (index) async {
                      setState(() {
                        _currentIndex = index;
                      });
                      await _initializeAndPlayVideo(index);
                    },
                    itemCount: widget.videos.length,
                    itemBuilder: (context, index) {
                      var video = widget.videos[index];
                      var controller = _controllers[index];
                      return VisibilityDetector(
                        key: Key('video-$index'),
                        onVisibilityChanged: (visibilityInfo) {
                          if (_isDisposing) return;
                          if (visibilityInfo.visibleFraction == 0 &&
                              controller != null &&
                              controller.value.isPlaying) {
                            controller.pause();
                          } else if (visibilityInfo.visibleFraction > 0 &&
                              controller != null &&
                              !controller.value.isPlaying) {
                            controller.play();
                          }
                        },
                        child: Stack(
                          children: [
                            Center(
                              child: controller != null
                                  ? Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: SizedBox(
                                          width: controller.value.size.width,
                                          height: controller.value.size.height,
                                          child: VideoPlayer(controller),
                                        ),
                                      ),
                                    )
                                  : CircularProgressIndicator(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 500.0, left: 24.0, right: 56.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      if (_user != null &&
                                          _user!['profile_img_link'] != null)
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              _user!['profile_img_link']),
                                          radius: 20.0,
                                        ),
                                      const SizedBox(width: 10.0),
                                      Text(
                                        _user != null
                                            ? _user!['username'] ??
                                                'Unknown User'
                                            : 'Loading',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
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
                                                  spotName: _spot != null ? _spot!['name'] ?? "Unknown Name" : 'Loading',
                                                  address: _spot != null ? _spot!['address'] ?? "No Address" : 'Loading',
                                                  contact: _spot != null ? _spot!['contact'] ?? "No Contact" : 'Loading',
                                                  hours: _spot != null ? _spot!['hours'] ?? "Hours Unavailable" : 'Loading',
                                                  parking: _spot != null ? _spot!['parking'] ?? false : false,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 22.0,
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(14.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 8.0, vertical: 4.0),
                                              child: Center(
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/image/icon/Location.svg',
                                                      width: 8.0,
                                                      height: 10.0,
                                                    ),
                                                    const SizedBox(width: 8.0),
                                                    Text(
                                                      _spot != null
                                                          ? _spot!['name'] ??
                                                              'Unknown Name'
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
                                  Row(
                                    children: [
                                      _hashtags != null
                                          ? Wrap(
                                              spacing: 8.0,
                                              children:
                                                  _hashtags!.map((hashtag) {
                                                return Text(
                                                  '# $hashtag',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                  ),
                                                );
                                              }).toList(),
                                            )
                                          : const Text(
                                              'Loading hashtags...',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0),
                                            ),
                                      const SizedBox(width: 6.0),
                                    ],
                                  ),
                                  Text(
                                    _spot != null
                                        ? _spot!['short_description'] ??
                                            'Unknown Description'
                                        : 'Loading',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10.0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Center(
                    child: _spotLocation != null
                        ? MapView(spotLocation: _spotLocation)
                        : CircularProgressIndicator(),
                  ),
                ],
              ),

              //Tabbar
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
                    indicatorColor: Colors.transparent,
                    indicatorWeight: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
