import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planZ/app_state.dart';
import 'package:planZ/common/dart/extension/context_extension.dart';
import 'package:planZ/common/widget/w_togglebar.dart';
import 'package:planZ/screen/main/tab/feed/f_spot_detail.dart';
import 'package:planZ/screen/main/tab/plan/f_cardlist_plan.dart';

import '../../../../common/common.dart';
import 'global.dart';

class MySaves extends StatefulWidget {
  const MySaves({super.key});

  @override
  State<MySaves> createState() => _MySavesState();
}

class _MySavesState extends State<MySaves> with SingleTickerProviderStateMixin {
  List<String> labels = ['Spots', 'Journeys'];
  late PageController _pageController;
  late TabController _tabController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? _user;
  Map<String, List<String>> spotImages = {};

  Future<void> _fetchUserData(String userId) async {
    try {
      DocumentSnapshot userSnapshot =
      await _firestore.collection('user').doc(userId).get();
      setState(() {
        _user = userSnapshot.data() as Map<String, dynamic>?;
        print('User data fetched: $_user');
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabController = TabController(length: labels.length, vsync: this);

    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _fetchUserData(currentUser.uid);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<DocumentSnapshot> _fetchSpotData(String spotId) async {
    return await _firestore.collection('spot').doc(spotId).get();
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
  Widget build(BuildContext context) {
    String currentLanguage = AppLangState.instance.appLanguage;
    List<dynamic> savedSpots = _user?['saved_spots'] ?? [];
    List<dynamic> savedJourneys = _user?['saved_journey'] ?? [];
    // print('selected spots are: $selectedSpots');

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: SizedBox(
              height: 24,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      // Navigator.pop(context, true);
                      Navigator.pop(context, selectedLocations);
                    },
                  ),
                ],
              ),
            ),
          ),
          //Toggle Bar
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: ToggleBarWidget(
              labels: labels,
              tabController: _tabController,
            ),
          ),

          // Spots and Journeys Tab View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Spots Tab
                savedSpots.isEmpty
                    ? Center(child: Text('No Saved spots'))
                    : ListView.builder(
                  itemCount: savedSpots.length,
                  itemBuilder: (context, index) {
                    String spotId = savedSpots[index];
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
                            return Center(
                                child: Text(
                                    'Error fetching spot details'));
                          } else if (!snapshot.hasData ||
                              !snapshot.data!.exists) {
                            return Center(
                                child: Text('Spot not found'));
                          } else {
                            var spotData = snapshot.data!.data()
                            as Map<String, dynamic>;
                            // print(spotData);
                            // print('????');

                            String spotName = spotData['translated_name']
                            ?[currentLanguage] ??
                                'No name';
                            String shortDescription =
                                spotData['translated_short_description']
                                ?[currentLanguage] ??
                                    'No description';
                            List<String> images =
                                spotImages[spotId] ?? [];
                            bool added = selectedSpots.any(
                                    (spot) => spot['spotName'] == spotName);

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (spotData != null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SpotDetail(
                                                        spotItem:
                                                        spotData),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Spot details are not available.')),
                                            );
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                image: images.isNotEmpty
                                                    ? DecorationImage(
                                                    image: NetworkImage(images[0]),
                                                    fit: BoxFit.cover)
                                                    : DecorationImage(
                                                  image: AssetImage(
                                                      'assets/image/fallbackImage.png'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            SizedBox(
                                              width: 213,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Text(
                                                    spotName,
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
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
                                                        fontWeight:
                                                        FontWeight
                                                            .w500,
                                                        color: context
                                                            .appColors
                                                            .placeholder,
                                                        overflow:
                                                        TextOverflow
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
                                              : Icons.add))
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
                // Journeys Tab
                savedJourneys.isEmpty
                    ? Center(child: Text('No saved journeys'))
                    : ListView.builder(
                  itemCount: savedJourneys.length,
                  itemBuilder: (context, index) {
                    String journeyId = savedJourneys[index];
                    return CardListPlan(journeyId: journeyId);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}