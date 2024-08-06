import 'package:flutter/material.dart';
import 'package:planZ/common/widget/w_togglebar.dart';
import 'package:planZ/screen/main/tab/feed/f_card_list.dart';
import 'package:planZ/screen/main/tab/feed/f_spot_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planZ/common/widget/w_searchbar.dart';
import 'package:planZ/app_state.dart';
import 'package:planZ/common/theme/color/abs_theme_colors.dart';

class FeedFragment extends StatefulWidget {
  final AbstractThemeColors themeColors;

  const FeedFragment({Key? key, required this.themeColors}) : super(key: key);

  @override
  State<FeedFragment> createState() => _FeedFragmentState();
}

class _FeedFragmentState extends State<FeedFragment>
    with SingleTickerProviderStateMixin {
  List<String> labels = ['Discover', 'Following'];

  late PageController _pageController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabController = TabController(length: labels.length, vsync: this);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    _pageController.jumpToPage(index);
  }

  Future<List<Map<String, dynamic>>> _fetchSpot() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('spot').limit(5).get();

    List<Map<String, dynamic>> spots = [];

    for (var doc in querySnapshot.docs) {
      var spotData = doc.data() as Map<String,dynamic>;

      //fetch from "image" subcollection
      QuerySnapshot imageSnapshot =
          await doc.reference.collection('image').get();
      List<String> imageLinks = imageSnapshot.docs
          .map((imageDoc) => imageDoc['image_link'] as String)
          .toList();

      spotData['image_links'] = imageLinks;
      spots.add(spotData);
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    String currentLanguage = AppLangState.instance.appLanguage;
    print("Current language in FeedFragment: $currentLanguage");
    return Column(
      children: [
        // Search Bar
        SearchBarWidget(themeColors: widget.themeColors),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 66, vertical: 22),
          child: ToggleBarWidget(
            labels: labels,
            pageController: _pageController,
            tabController: _tabController,
            themeColors: widget.themeColors,
          ),
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: labels.map((label) {
              return FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchSpot(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No Spots Found'));
                  } else {
                    var spots = snapshot.data!;

                    return ListView.builder(
                      itemCount: spots.length,
                      itemBuilder: (context, index) {
                        var spot = spots[index];

                        // Extract hashtags for the current language
                        List<String> hashtags = [];
                        if (spot['translated_hashtags'] != null) {
                          var translatedHashtags = spot['translated_hashtags'];
                          for (var i = 0; i < translatedHashtags.length; i++) {
                            hashtags.add(translatedHashtags[i.toString()]
                                [currentLanguage]);
                          }
                        }

                        List<String> imageLinks = spot['image_links'] ?? [];

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SpotDetail(
                                  spotName: spot['translated_name']
                                          [currentLanguage] ??
                                      'No Title',
                                  address: spot['translated_address'][currentLanguage] ??
                                      spot['translated_address']['en'] ?? "No Address",
                                  contact: spot['contact'] ?? "No Contact",
                                  hours: spot['translated_hours'][currentLanguage] ?? "Hours Unavailable",
                                  parking: spot['parking'] ?? "No Parking Info",
                                  hashtags: hashtags,
                                  imageLinks: imageLinks,
                                ),
                              ),
                            );
                          },
                          child: CardList(
                            spotTitle: spot['translated_name']
                                    [currentLanguage] ??
                                'No Info',
                            shortDescription:
                                spot['translated_short_description']
                                        [currentLanguage] ??
                                    'No Info',
                            area: spot['translated_area'][currentLanguage] ??
                                spot['translated_area']['en'] ?? "No Info",
                            hashtags: hashtags,
                            themeColors: widget.themeColors,
                            imageLinks: imageLinks,
                          ),
                        );
                      },
                    );
                  }
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
