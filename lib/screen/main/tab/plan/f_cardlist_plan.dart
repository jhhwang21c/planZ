
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:planZ/app_state.dart';
import 'package:planZ/common/dart/extension/context_extension.dart';
import 'package:planZ/screen/main/tab/feed/f_spot_detail.dart';
import 'package:planZ/screen/main/tab/plan/global.dart';

class CardListPlan extends StatefulWidget {
  final String journeyId;

  CardListPlan({
    super.key,
    required this.journeyId,
  });

  @override
  State<CardListPlan> createState() => _CardListPlanState();
}

class _CardListPlanState extends State<CardListPlan> {
  List<String> imageLinks = [];
  bool isExpanded = false;
  Map<String, List<String>> spotImages = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot>> _fetchJourneySpots(String journeyId) async {
    QuerySnapshot journeySpotsSnapshot = await FirebaseFirestore.instance
        .collection('journey')
        .doc(journeyId)
        .collection('journey_spot')
        .get();
    return journeySpotsSnapshot.docs;
  }

  Future<DocumentSnapshot> _fetchSpotData(String spotId) async {
    return await FirebaseFirestore.instance.collection('spot').doc(spotId).get();
  }

  Future<Map<String, dynamic>> _fetchJourneyData(String journeyId) async {
    DocumentSnapshot journeyDoc = await _firestore.collection('journey').doc(journeyId).get();
    return journeyDoc.data() as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> _fetchJourneyAndSpots(String journeyId) async {
    final results = await Future.wait([
      _fetchJourneyData(journeyId),
      _fetchJourneySpots(journeyId),
    ]);

    Map<String, dynamic> journeyData = results[0] as Map<String, dynamic>;
    List<DocumentSnapshot> journeySpots = results[1] as List<DocumentSnapshot>;

    return {
      'journeyData': journeyData,
      'journeySpots': journeySpots,
    };
  }

  void fetchImageLinks(String spotId) async {
    try {
      QuerySnapshot imageSnapshot = await FirebaseFirestore.instance
          .collection('spot')
          .doc(spotId)
          .collection('image')
          .get();

      List<String> links = imageSnapshot.docs
          .map((doc) => doc['image_link'] as String? ?? '')
          .toList();

      setState(() {
        spotImages[spotId] = links;
      });
    } catch (e) {
      print('Error fetching image links: $e');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String currentLanguage = AppLangState.instance.appLanguage;

    return FutureBuilder(
        future: _fetchJourneyAndSpots(widget.journeyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data available'));
          }

          Map<String, dynamic> journeyData = snapshot.data!['journeyData'];
          List<DocumentSnapshot> journeySpots = snapshot.data!['journeySpots'];

          List<String> hashtags = [];

          if (journeyData['translated_hashtags'] != null) {
            var translatedHashtags = journeyData['translated_hashtags'];
            for (var i = 0; i < translatedHashtags.length; i++) {
              hashtags.add(translatedHashtags[i.toString()][currentLanguage]);
            }
          }

          String area = journeyData['translated_area']?[currentLanguage] ??
              'No Info';
          String spotName = journeyData['translated_title']?[currentLanguage] ??
              'No Info';
          String shortDescription = journeyData['translated_description']?[currentLanguage] ??
              'No Info';

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              child: Column(
                children: [
                  //upper card
                  Stack(children: [
                    Container(
                      height: 150.0,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                        gradient: LinearGradient(
                          colors: [context.appColors.mainBlack, Colors.blue],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [0, 0.4],
                        ),
                        image: journeyData['main_image'].isNotEmpty
                            ? DecorationImage(
                            image: NetworkImage(journeyData['main_image']),
                            fit: BoxFit.cover)
                            : DecorationImage(
                          image: AssetImage('assets/image/fallbackImage.png'),
                          fit: BoxFit.cover,),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 120, left: 12),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            if (area != 'No Info')
                              Container(
                                height: 20,
                                decoration: BoxDecoration(
                                  color: context.appColors.blackFillHalfOp,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/image/icon/Location.svg',
                                        width: 8,
                                        height: 10,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        area,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0),
                                child: hashtags.isNotEmpty
                                    ? Wrap(
                                  spacing: 8.0,
                                  children: hashtags.map((hashtag) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      decoration: BoxDecoration(
                                        color: context.appColors
                                            .blackFillHalfOp,
                                        borderRadius:
                                        BorderRadius.circular(100),
                                      ),
                                      child: Text(
                                        '# $hashtag',
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                )
                                    : const Text(
                                  'Loading hashtags...',
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ]),

                  //bottom card
                  Container(
                    decoration: BoxDecoration(
                      color: context.appColors.mainWhite,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x64959DA5),
                          spreadRadius: 0,
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 19.5, bottom: 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(spotName,
                                  style: const TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  shortDescription,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        setState(() {
                                          for (var journeySpot in journeySpots) {
                                            var spotData = journeySpot
                                                .data() as Map<String, dynamic>;
                                            var spotId = spotData['spot_id'];

                                            //fetch spot details
                                            _fetchSpotData(spotId).then((
                                                spotSnapshot) {
                                              var spotDetails = spotSnapshot
                                                  .data() as Map<String,
                                                  dynamic>;
                                              String spotName = spotDetails['translated_name']?[currentLanguage] ??
                                                  "No name";
                                              List<
                                                  String> images = spotImages[spotId] ??
                                                  [];

                                              if (selectedSpots.any((spot) =>
                                              spot['spotName'] == spotName)) {
                                                selectedSpots.removeWhere(
                                                        (spot) =>
                                                    spot['spotName'] ==
                                                        spotName);
                                              } else {
                                                selectedSpots.add({
                                                  'spotName': spotName,
                                                  'imageUrl': images.isNotEmpty
                                                      ? images[0]
                                                      : '',
                                                });
                                              }
                                            });
                                          }
                                        });
                                      },
                                      icon: Icon(selectedSpots.any((
                                          spot) => spot['spotName'] == spotName)
                                          ? Icons.check_circle_rounded
                                          : Icons.add)
                                  ),
                                  IconButton(
                                    icon: Icon(isExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down),
                                    onPressed: () {
                                      setState(() {
                                        isExpanded = !isExpanded;
                                      });
                                    },
                                  )
                                ],
                              )
                            ],
                          ), if (isExpanded)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: journeySpots.length,
                              itemBuilder: (context, index) {
                                var journeySpot = journeySpots[index]
                                    .data() as Map<String, dynamic>;
                                var spotId = journeySpot['spot_id'];
                                if (!spotImages.containsKey(spotId)) {
                                  fetchImageLinks(spotId);
                                }

                                return FutureBuilder<DocumentSnapshot>(
                                    future: _fetchSpotData(spotId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(child: Text(
                                            'Error fetching spot details'));
                                      } else if (!snapshot.hasData ||
                                          !snapshot.data!.exists) {
                                        return Center(
                                            child: Text('Spot not found'));
                                      } else {
                                        var spotData = snapshot.data!
                                            .data() as Map<String, dynamic>;
                                        // print(spotData);

                                        String spotName = spotData['translated_name']?[currentLanguage] ??
                                            'No name';
                                        String shortDescription = spotData['translated_short_description']?[currentLanguage] ??
                                            'No description';
                                        List<
                                            String> images = spotImages[spotId] ??
                                            [];
                                        bool added = selectedSpots.any((spot) =>
                                        spot['spotName'] == spotName);

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              right: 15.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      if (spotData != null) {
                                                        Navigator.push(context,
                                                          MaterialPageRoute(
                                                            builder: (
                                                                context) =>
                                                                SpotDetail(
                                                                    spotItem: spotData),
                                                          ),
                                                        );
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                            context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                              content: Text(
                                                                  'Spot details are not available.')),
                                                        );
                                                      }
                                                    },
                                                    child:
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 60,
                                                          height: 60,
                                                          decoration: BoxDecoration(
                                                            image: images
                                                                .isNotEmpty
                                                                ? DecorationImage(
                                                                image: NetworkImage(
                                                                    images[0]),
                                                                fit: BoxFit
                                                                    .cover)
                                                                : DecorationImage(
                                                              image: AssetImage(
                                                                  'assets/image/fallbackImage.png'),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        const
                                                        SizedBox(width: 16),
                                                        SizedBox(
                                                          width: 180,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                spotName,
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight
                                                                        .w500,
                                                                    fontSize: 16,
                                                                    color: context
                                                                        .appColors
                                                                        .mainBlack),
                                                              ),
                                                              Text(
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                                shortDescription,
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight
                                                                        .w500,
                                                                    color: context
                                                                        .appColors
                                                                        .placeholder,
                                                                    overflow: TextOverflow
                                                                        .ellipsis),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          if (added) {
                                                            selectedSpots.removeWhere((spot) => spot['spotName'] == spotName);
                                                            selectedLocations.removeWhere((location) => location['spotName'] == spotName);
                                                          } else {
                                                            selectedSpots.add({
                                                              'spotName': spotName,
                                                              'imageUrl': images.isNotEmpty ? images[0] : '',
                                                            });
                                                            selectedLocations.add({
                                                              'spotName': spotName,
                                                              'location': spotData['location'], // Assuming location is stored in the spotData
                                                            });
                                                          }
                                                        });
                                                      },
                                                      icon: Icon(added
                                                          ? Icons
                                                          .check_circle_rounded
                                                          : Icons.add)),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                            ],
                                          ),
                                        );
                                      }
                                    });
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 28,
                  )
                ],
              ),
            ),
          );
        }
    );
  }}