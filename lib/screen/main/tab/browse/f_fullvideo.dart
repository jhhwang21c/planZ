import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FullVideo extends StatefulWidget {
  final List<Map<String, dynamic>> videos;
  final int initialIndex;

  const FullVideo({super.key, required this.videos, required this.initialIndex});

  @override
  _FullVideoState createState() => _FullVideoState();
}

class _FullVideoState extends State<FullVideo> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late PageController _pageController;
  late List<VideoPlayerController> _controllers;
  Map<String, dynamic>? _user;
  Map<String, dynamic>? _spot;
  List<dynamic>? _hashtags;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _initializeVideoControllers();
  }

  Future<void> _initializeVideoControllers() async {
    _controllers = widget.videos.map((video) {
      return VideoPlayerController.network(video['video_link']);
    }).toList();

    for (var controller in _controllers) {
      await controller.initialize();
      controller.setLooping(true);
    }

    setState(() {
      _controllers[widget.initialIndex].play();
    });

    await _fetchData(widget.videos[widget.initialIndex]);
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
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controllers.isEmpty
          ? Center(child: CircularProgressIndicator())
          : PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: (index) async {
          for (var controller in _controllers) {
            controller.pause();
          }
          _controllers[index].play();
          await _fetchData(widget.videos[index]);
        },
        itemCount: widget.videos.length,
        itemBuilder: (context, index) {
          var video = widget.videos[index];
          var controller = _controllers[index];
          return Stack(
            children: [
              Center(
                child: Container(
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
                ),
              ),
              // Display user and spot information
              Padding(
                padding: EdgeInsets.only(top: 500.0, left: 24.0, right: 56.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //username
                    Row(
                      children: [
                        if (_user != null &&
                            _user!['profile_img_link'] != null)
                          CircleAvatar(
                            backgroundImage:
                            NetworkImage(_user!['profile_img_link']),
                            radius: 20.0,
                          ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          _user != null
                              ? _user!['username'] ?? 'Unknown User'
                              : 'Loading',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0, // Adjust font size as needed
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    //Tags
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Container(
                            height: 22.0,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(14.0),
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
                                          ? _spot!['name'] ?? 'Unknown Name'
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
                        ],
                      ),
                    ),

                    //HashTags
                    Row(
                      children: [
                        _hashtags != null
                            ? Wrap(
                          spacing: 8.0,
                          children: _hashtags!.map((hashtag) {
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
                              color: Colors.white, fontSize: 12.0),
                        ),
                        const SizedBox(
                          width: 6.0,
                        ),
                      ],
                    ),

                    //description
                    Text(
                      _spot != null
                          ? _spot!['short_description'] ??
                          'Unknown Description'
                          : 'Loading',
                      style: TextStyle(color: Colors.white, fontSize: 10.0),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
