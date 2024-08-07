import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:planZ/app_state.dart';

import '../../../../common/theme/color/abs_theme_colors.dart';

class CardList extends StatelessWidget {
  final Map<String, dynamic> item;
  final AbstractThemeColors themeColors;

  CardList({
    super.key,
    required this.item,
    required this.themeColors,
  });

  @override
  Widget build(BuildContext context) {
    String currentLanguage = AppLangState.instance.appLanguage;

    List<String> hashtags = [];

    if (item['translated_hashtags'] != null) {
      var translatedHashtags = item['translated_hashtags'];
      for (var i = 0; i < translatedHashtags.length; i++) {
        hashtags.add(translatedHashtags[i.toString()][currentLanguage]);
      }
    }

    List<String> imageLinks = item['image_links'] ?? [];
    String area = item['translated_area']?[currentLanguage] ?? 'No Info';
    String spotName = item['translated_title']?[currentLanguage] ?? item['translated_name'] ? [currentLanguage] ?? 'No Info';
    String shortDescription = item['translated_short_description']?[currentLanguage] ?? item['translated_description']?[currentLanguage] ?? 'No Info';


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
                    colors: [themeColors.mainBlack, Colors.blue],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0, 0.4],
                  ),
                  image: imageLinks.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(imageLinks[0]), fit: BoxFit.cover)
                      : DecorationImage(image: AssetImage('assets/image/fallbackImage.png'), fit: BoxFit.cover,),
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
                          color: themeColors.blackFillHalfOp,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: hashtags.isNotEmpty
                              ? Wrap(
                                  spacing: 8.0,
                                  children: hashtags.map((hashtag) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      decoration: BoxDecoration(
                                        color: themeColors.blackFillHalfOp,
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
                color: themeColors.mainWhite,
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
                          child: Text(
                            spotName,
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
                          shortDescription,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        )),
                        SvgPicture.asset('assets/image/icon/Save.svg')
                      ],
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
}
