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
  List<String> labels = ['Browse', 'Map'];
  late VideoPlayerController _controller;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchVideos() async {
    QuerySnapshot querySnapshot = await _firestore.collection('video').get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<void> _fetchUserData(String userId) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('user').doc(userId).get();
    setState(() {
      var _user = userSnapshot.data() as Map<String, dynamic>?;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.video['video_link'])
      ..initialize().then((_) {
        setState(() {_fetchUserData(widget.video['user_id']);});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: labels.length,
      child: Scaffold(
        body: Stack(children: [
          //Video
          _controller.value.isInitialized
              ? Center(
                  child: Expanded(
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
                  ),
                )
              : const CircularProgressIndicator(),

          //Tab Bar
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 67.0, vertical: 12.0),
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

          //Info
          const Padding(
            padding: EdgeInsets.only(top: 500.0, left: 24.0, right: 233.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@username',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0, // Adjust font size as needed
                    fontWeight: FontWeight.bold,
                  ),
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
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
