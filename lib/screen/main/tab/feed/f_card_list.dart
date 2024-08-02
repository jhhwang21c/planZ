import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardList extends StatelessWidget {
  final String spotTitle;
  final String shortDescription;
  final String area;
  List<dynamic>? hashtags;

  CardList(
      {required this.spotTitle,
      required this.shortDescription,
      required this.area,
      required this.hashtags,
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        // color: Colors.white,
        child: Column(
          children: [
            //upper card
            Stack(children: [
              Container(
                height: 150.0,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black.withOpacity(0.25),
                  //     spreadRadius: 2,
                  //     blurRadius: 5,
                  //     offset: Offset(0, 4),
                  //   ),
                  // ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 120, left: 12),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
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
                            child: hashtags != null
                                ? Wrap(
                                    spacing: 8.0,
                                    children: hashtags!.map((hashtag) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.3),
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
                                    style: TextStyle(fontSize: 12.0,color: Colors.white),
                                  ),

                      ),
                    ),
                  ],
                ),
              )
            ]),

            //bottom card
            Container(
              height: 88.0,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 18),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          spotTitle,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text(
                          shortDescription,
                          style: TextStyle(
                            fontSize: 12,
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
