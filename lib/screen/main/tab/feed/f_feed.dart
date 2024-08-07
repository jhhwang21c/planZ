import 'package:flutter/material.dart';
import 'package:planZ/common/widget/w_togglebar.dart';
import 'package:planZ/screen/main/tab/feed/f_card_list.dart';
import 'package:planZ/screen/main/tab/feed/f_journey.dart';
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

  Future<List<Map<String, dynamic>>> _fetchData() async {
    List<Map<String, dynamic>> combinedData = [];

    QuerySnapshot spotQuerySnapshot =
        await FirebaseFirestore.instance.collection('spot').limit(3).get();

    for (var doc in spotQuerySnapshot.docs) {
      var spotData = doc.data() as Map<String, dynamic>;
      spotData['id'] = doc.id;

      spotData['type'] = 'spot';
      combinedData.add(spotData);
    }

    QuerySnapshot journeyQuerySnapshot =
        await FirebaseFirestore.instance.collection('journey').get();

    for (var doc in journeyQuerySnapshot.docs) {
      var journeyData = doc.data() as Map<String, dynamic>;
      journeyData['id'] = doc.id;

      journeyData['type'] = 'journey';
      combinedData.add(journeyData);
    }

    return combinedData;
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
                future: _fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No Data Found'));
                  } else {
                    var items = snapshot.data!;

                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        var item = items[index];

                        // Extract hashtags for the current language
                        List<String> hashtags = [];
                        if (item['translated_hashtags'] != null) {
                          var translatedHashtags = item['translated_hashtags'];
                          for (var i = 0; i < translatedHashtags.length; i++) {
                            hashtags.add(translatedHashtags[i.toString()]
                                [currentLanguage]);
                          }
                        }

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => item['type'] == 'spot'
                                    ? SpotDetail(
                                        spotItem: item,
                                      )
                                    : JourneyPage(
                                  journeyItem: item,
                                ),
                              ),
                            );
                          },
                          child: CardList(item: item,)
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
