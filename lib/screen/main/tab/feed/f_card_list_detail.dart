import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CardListDetail extends StatefulWidget {
  final String title;

  CardListDetail({required this.title});

  @override
  State<CardListDetail> createState() => _CardListDetailState();
}

class _CardListDetailState extends State<CardListDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Title"), Text("@username")],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // hashtags
                      Text("#hashtags"),
                      SvgPicture.asset(
                        'assets/image/icon/Save.svg',
                        width: 24.0,
                        height: 24.0,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/image/icon/Car.svg',
                      width: 10.0,
                      height: 10.0,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text("4 min"),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SvgPicture.asset(
                        'assets/image/icon/Transit.svg',
                        width: 10.0,
                        height: 10.0,
                      ),
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text("4 min"),
                    ),
                    SvgPicture.asset(
                      'assets/image/icon/Walk.svg',
                      width: 10.0,
                      height: 10.0,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text("15 min"),
                  ],
                ),

                // pictures
                Padding(
                  padding: const EdgeInsets.only(top: 36.0, bottom: 20.0),
                  child: SizedBox(
                    height: 270.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Container(
                          color: Colors.grey,
                          width: 167.0,
                        ),
                        SizedBox(
                          width: 24.0,
                        ),
                        Container(
                          color: Colors.grey,
                          width: 167.0,
                        ),
                        SizedBox(
                          width: 24.0,
                        ),
                        Container(
                          color: Colors.grey,
                          width: 167.0,
                        ),
                        SizedBox(
                          width: 24.0,
                        ),
                      ],
                    ),
                  ),
                ),

                // 영업정보
                Container(
                  child: Column(
                    children: [
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
                              SizedBox(
                                width: 8.0,
                              ),
                              Text("Open"),
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
                                'assets/image/icon/Address.svg',
                                width: 14.0,
                                height: 14.0,
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Text("Address"),
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
                              SizedBox(
                                width: 8.0,
                              ),
                              Text("Parking"),
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
                              SizedBox(
                                width: 8.0,
                              ),
                              Text("Contact"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100.0), // Add space to prevent content from being hidden behind the bottom sheet
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              height: 78.0,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(120, 50), // width and height
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                      ),
                      child: Text("Reserve"),
                    ),
                    SizedBox(width: 24.0), // Space between the buttons
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(120, 50), // width and height
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                      ),
                      child: Text("Start here"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}