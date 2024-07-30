import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullVideo extends StatefulWidget {
  final Map<String, dynamic> video;

  const FullVideo({super.key, required this.video});

  @override
  _FullVideoState createState() => _FullVideoState();
}

class _FullVideoState extends State<FullVideo> {
  late VideoPlayerController _controller;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? _user;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
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

              // Info
              Padding(
                padding:
                const EdgeInsets.only(top: 500.0, left: 24.0, right: 233.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _user != null
                          ? _user!['username'] ?? 'Unknown User'
                          : 'Loading...',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Row(
                      children: [
                        Text(
                          '@Location',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '@Spot Name',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '@View Journey',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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