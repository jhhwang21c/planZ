import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:planZ/app_state.dart';
import 'package:planZ/common/dart/extension/context_extension.dart';
import 'package:video_player/video_player.dart';

class JourneyPage extends StatelessWidget {
  final Map<String, dynamic> item;

  const JourneyPage({super.key, required this.item});

  Future<List<Map<String, dynamic>>> _fetchJourneySpots(
      String journeyId) async {
    List<Map<String, dynamic>> journeySpots = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('journey')
        .doc(journeyId)
        .collection('journey_spot')
        .get();

    for (var doc in querySnapshot.docs) {
      var journeySpotData = doc.data() as Map<String, dynamic>;
      journeySpotData['id'] = doc.id;

      if (journeySpotData.containsKey('video_id')) {
        String videoId = journeySpotData['video_id'];
        DocumentSnapshot videoDoc = await FirebaseFirestore.instance
            .collection('video')
            .doc(videoId)
            .get();
        if (videoDoc.exists) {
          journeySpotData['video_link'] = videoDoc['video_link'];
        }
      }

      if (journeySpotData.containsKey('spot_id')) {
        String spotId = journeySpotData['spot_id'];
        DocumentSnapshot spotDoc = await FirebaseFirestore.instance
            .collection('spot')
            .doc(spotId)
            .get();
        if (spotDoc.exists) {
          var spotData = spotDoc.data() as Map<String, dynamic>;
          journeySpotData['translated_name'] = spotData['translated_name'];
        }
      }

      journeySpots.add(journeySpotData);
    }

    return journeySpots;
  }

  @override
  Widget build(BuildContext context) {
    String currentLanguage = AppLangState.instance.appLanguage;

    List<String> hashtags = [];
    String journeyName =
        item['translated_title']?[currentLanguage] ?? 'No Name';
    String description =
        item['translated_description']?[currentLanguage] ?? 'No Description';
    String journeyId = item['id'];

    if (item['translated_hashtags'] != null) {
      var translatedHashtags = item['translated_hashtags'];
      for (var i = 0; i < translatedHashtags.length; i++) {
        hashtags.add(translatedHashtags[i.toString()][currentLanguage]);
      }
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          //image carousel
          Container(
            height: 282,
            color: Colors.grey,
            child: Center(
              child: Text('Image Carousel'),
            ),
          ),

          //journey info
          Container(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Column(
                children: [
                  //first line
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          journeyName,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text('@kiyeorida')
                    ],
                  ),
                  //second line
                  Padding(
                    padding: EdgeInsets.only(top: 9, bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: hashtags.isNotEmpty
                              ? Wrap(
                                  spacing: 12.0,
                                  children: hashtags.map((hashtag) {
                                    return Container(
                                      height: 20,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1.0,
                                            color: context.appColors.mainGray),
                                        color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: Text(
                                        '# $hashtag',
                                        style: const TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : const Text(
                                  'Loading hashtags...',
                                  style: TextStyle(
                                      fontSize: 10.0, color: Colors.white),
                                ),
                        ),
                        SvgPicture.asset(
                          'assets/image/icon/Save.svg',
                          width: 24,
                          height: 24,
                        )
                      ],
                    ),
                  ),
                  //third line
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          description,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                      ),
                      SvgPicture.asset('assets/image/icon/Add.svg')
                    ],
                  )
                ],
              ),
            ),
          ),

          Container(
            height: 10,
            color: context.appColors.baseGray,
          ),

          //journey spot
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchJourneySpots(journeyId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No spots found'));
                } else {
                  var journeySpots = snapshot.data!;

                  return Column(
                    children: journeySpots.map((spot) {
                      String spotName = spot['translated_name']
                              ?[currentLanguage] ??
                          'No Info';
                      String spotDescription = spot['translated_description']
                              ?[currentLanguage] ??
                          'No Description';

                      List<String> spotImages = [];
                      if (spot['image_link'] is List) {
                        spotImages =
                            List<String>.from(spot['image_link'] ?? []);
                      } else if (spot['image_link'] is String) {
                        spotImages = [spot['image_link']];
                      }

                      String? videoLink;
                      if (spot.containsKey('video_link')) {
                        videoLink = spot['video_link'];
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // First line
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    spotName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                  ),
                                ),
                                SvgPicture.asset('assets/image/icon/Save.svg'),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              spotDescription,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 12),
                            // Spot images
                            if (spotImages.isNotEmpty)
                              Container(
                                height: 310,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: spotImages.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 20.0),
                                      child: Row(
                                        children: [
                                          AspectRatio(
                                            aspectRatio: 9 / 16,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              // Adjust the radius as needed
                                              child: Image.network(
                                                spotImages[index],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            else if (videoLink != null)
                              Container(
                                height: 310,
                                child: AspectRatio(
                                  aspectRatio: 9 / 16,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: VideoWidget(videoUrl: videoLink),
                                  ),
                                ),
                              )
                            else
                              SizedBox.shrink(),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VideoWidget extends StatefulWidget {
  final String videoUrl;

  const VideoWidget({super.key, required this.videoUrl});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(
            () {}); // Ensure the first frame is shown after the video is initialized
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Center(child: CircularProgressIndicator());
  }
}
