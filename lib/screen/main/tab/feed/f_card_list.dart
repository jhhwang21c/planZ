import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../common/theme/color/abs_theme_colors.dart';

class CardList extends StatefulWidget {
  final String spotTitle;
  final String shortDescription;
  final String area;
  final AbstractThemeColors themeColors;
  List<dynamic>? hashtags;

  CardList({
    required this.spotTitle,
    required this.shortDescription,
    required this.area,
    required this.hashtags,
    required this.themeColors,
  });

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  @override
  Widget build(BuildContext context) {
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
                    colors: [widget.themeColors.mainBlack, Colors.blue],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0, 0.4],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 120, left: 12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: widget.themeColors.blackFillHalfOp,
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
                                widget.area,
                                style: TextStyle(
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
                          child: widget.hashtags != null
                              ? Wrap(
                                  spacing: 8.0,
                                  children: widget.hashtags!.map((hashtag) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      decoration: BoxDecoration(
                                        color: widget.themeColors.blackFillHalfOp,
                                        borderRadius: BorderRadius.circular(100),
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
                color: widget.themeColors.mainWhite,
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
                padding: const EdgeInsets.only(left: 15, right: 15, top: 19.5,bottom: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.spotTitle,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold
                            ,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height:12 ,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text(
                          widget.shortDescription,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400
                          ),
                        )),
                        SvgPicture.asset('assets/image/icon/Save.svg')
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 28,
            )
          ],
        ),
      ),
    );
  }
}
