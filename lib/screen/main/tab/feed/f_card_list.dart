import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:planZ/app_state.dart';
import 'package:planZ/common/dart/extension/context_extension.dart';


class CardList extends StatefulWidget {
  final bool isSpot;
  final Map<String, dynamic>? item;

  CardList({
    super.key,
    required this.item,
    this.isSpot = true,
  });

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  List<String> imageLinks = [];

  @override
  void initState() {
    super.initState();
    fetchImageLinks();
  }

  void fetchImageLinks() async {
    try {
      QuerySnapshot imageSnapshot = await FirebaseFirestore.instance
          .collection('spot')
          .doc(widget.item!['id'])
          .collection('image')
          .get();

      List<String> links = imageSnapshot.docs
          .map((doc) => doc['image_link'] as String? ?? '')
          .toList();

      setState(() {
        imageLinks = links;
      });
    } catch (e) {
      print('Error fetching image links: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentLanguage = AppLangState.instance.appLanguage;

    List<String> hashtags = [];

    if (widget.item!['translated_hashtags'] != null) {
      var translatedHashtags = widget.item!['translated_hashtags'];
      for (var i = 0; i < translatedHashtags.length; i++) {
        hashtags.add(translatedHashtags[i.toString()][currentLanguage]);
      }
    }

    String area = widget.item!['translated_area']?[currentLanguage] ?? 'No Info';
    String spotName = widget.item!['translated_title']?[currentLanguage] ?? widget.item!['translated_name'] ? [currentLanguage] ?? 'No Info';
    String shortDescription = widget.item!['translated_short_description']?[currentLanguage] ?? widget.item!['translated_description']?[currentLanguage] ?? 'No Info';

    String imageUrl = '';
    if (widget.isSpot && imageLinks.isNotEmpty) {
      imageUrl = imageLinks[0];
    } else if (!widget.isSpot) {
      imageUrl = widget.item!['main_image'];
    }

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
                  image: imageUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(imageUrl), fit: BoxFit.cover)
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
                          color: context.appColors.blackFillHalfOp,
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
                                        color: context.appColors.blackFillHalfOp,
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
                              overflow: TextOverflow.ellipsis,
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
