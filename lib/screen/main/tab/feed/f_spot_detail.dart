import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:planZ/app_state.dart';
import 'package:planZ/common/common.dart';
import 'package:video_player/video_player.dart';

class SpotDetail extends StatefulWidget {
  final Map<String, dynamic>? spotItem;

  SpotDetail({
    required this.spotItem,
  });

  @override
  State<SpotDetail> createState() => _SpotDetailState();
}

class _SpotDetailState extends State<SpotDetail> {
  List<String> videoLinks = [];
  List<VideoPlayerController> _videoControllers = [];
  List<String> imageLinks = [];

  @override
  void initState() {
    super.initState();
    fetchVideoLinks();
    fetchImageLinks();
  }

  void fetchVideoLinks() async {
    try {
      if (widget.spotItem?['id'] != null) {
        QuerySnapshot videoSnapshot = await FirebaseFirestore.instance
            .collection('video')
            .where('spot_id', isEqualTo: widget.spotItem?['id'])
            .get();

        List<String> links = videoSnapshot.docs
            .map((doc) => doc['video_link'] as String? ?? '')
            .toList();

        setState(() {
          videoLinks = links;
          _videoControllers = links
              .where((link) => link.isNotEmpty)
              .map((link) =>
          VideoPlayerController.network(link)
            ..initialize())
              .toList();
        });
      }
    } catch (e) {
      print('Error fetching video links: $e');
    }
  }

  void fetchImageLinks() async {
    try {
      if (widget.spotItem?['id'] != null) {
        QuerySnapshot imageSnapshot = await FirebaseFirestore.instance
            .collection('spot')
            .doc(widget.spotItem?['id'])
            .collection('image')
            .get();

        List<String> links = imageSnapshot.docs
            .map((doc) => doc['image_link'] as String? ?? '')
            .toList();

        setState(() {
          imageLinks = links;
        });
      }
    } catch (e) {
      print('Error fetching image links: $e');
    }
  }


  @override
  void dispose() {
    super.dispose();
    for (var controller in _videoControllers) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentLanguage = AppLangState.instance.appLanguage;
    String spotName =  widget.spotItem?['translated_name']?[currentLanguage]  ?? 'No Info';
    String address = widget.spotItem?['translated_address']?[currentLanguage] ?? 'No Address';
    String contact = widget.spotItem?['contact'] ?? 'No Contact';
    String hours = widget.spotItem?['translated_hours']?[currentLanguage] ??'hours unavailable';
    String parking = widget.spotItem?['parking'] == true ? 'Parking Available' : 'Parking unavailable';

    List<String> hashtags = [];
    if (widget.spotItem?['translated_hashtags'] != null) {
      var translatedHashtags = widget.spotItem?['translated_hashtags'];
      for (var i = 0; i < translatedHashtags.length; i++) {
        hashtags.add(translatedHashtags[i.toString()]?[currentLanguage] ?? '');
      }
    }


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: <Widget>[
            Container(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      spotName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/image/icon/Save.svg',
                      width: 24.0,
                      height: 24.0,
                    ),
                  ],
                )),

            Container(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
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
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/image/icon/Car.svg',
                    width: 12.0,
                    height: 12.0,
                  ),
                  const SizedBox(
                    width: 4.0,
                  ),
                  const Text(
                    "4 min",
                    style: TextStyle(fontSize: 13),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SvgPicture.asset(
                      'assets/image/icon/Transit.svg',
                      width: 14.0,
                      height: 14.0,
                    ),
                  ),
                  const SizedBox(
                    width: 4.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Text("4 min"),
                  ),
                  SvgPicture.asset(
                    'assets/image/icon/Walk.svg',
                    width: 14.0,
                    height: 14.0,
                  ),
                  const SizedBox(
                    width: 4.0,
                  ),
                  const Text("15 min"),
                ],
              ),
            ),

            //buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.grey,
                          // Text color
                          minimumSize: const Size(0, 40),
                          // Width and height
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(100), // Rounded corners
                          ), // Shadow elevation
                        ),
                        child: const Text(
                          "Reserve",
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.grey,
                          // Text color
                          minimumSize: const Size(0, 40),
                          // Width and height
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(100), // Rounded corners
                          ), // Shadow elevation
                        ),
                        child: const Text(
                          "Add to Plan",
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // pictures & videos
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                height: 270.0,
                child: imageLinks.isEmpty && videoLinks.isEmpty
                    ? const Center(
                        child: Text("No images or videos available"),
                      )
                    : ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          if (imageLinks.isNotEmpty)
                            ...imageLinks.map((imageLink) => Row(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 9 / 16,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4.0), // Adjust the radius as needed
                                        child: Image.network(
                                          imageLink,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                  ],
                                )),
                          if (videoLinks.isNotEmpty)
                            ..._videoControllers.map((controller) => Row(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 9 / 16,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4.0), // Border radius
                                        child: VideoPlayer(controller),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                  ],
                                )),
                        ],
                      ),
              ),
            ),

            // 영업정보
            Container(
              child: Column(
                children: [
                  SizedBox(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade200,
                            // Color of the border
                            width: 1.0, // Width of the border
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/image/icon/Clock.svg',
                              width: 14.0,
                              height: 14.0,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Expanded(child: Text(hours)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade200,
                            // Color of the border
                            width: 1.0, // Width of the border
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/image/icon/Address.svg',
                            width: 14.0,
                            height: 14.0,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Expanded(child: Text(address)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade200,
                            // Color of the border
                            width: 1.0, // Width of the border
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/image/icon/Parking.svg',
                            width: 14.0,
                            height: 14.0,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(parking),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade200,
                            // Color of the border
                            width: 1.0, // Width of the border
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/image/icon/Clock.svg',
                            width: 14.0,
                            height: 14.0,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text("Contact: (+82) ${contact}"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
