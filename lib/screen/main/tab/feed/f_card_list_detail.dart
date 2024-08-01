import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CardListDetail extends StatefulWidget {
  final String spotName;
  final String address;
  final String contact;
  final String hours;
  final bool parking;

  CardListDetail({
    required this.spotName,
    required this.address,
    required this.contact,
    required this.hours,
    required this.parking,
  });

  @override
  State<CardListDetail> createState() => _CardListDetailState();
}

class _CardListDetailState extends State<CardListDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.spotName),
                    SvgPicture.asset(
                      'assets/image/icon/Save.svg',
                      width: 24.0,
                      height: 24.0,
                    ),
                  ],
                )),

            Container(
              padding: EdgeInsets.only(top: 12.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("#hashtags")),
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

            Center(
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
                  const SizedBox(width: 24.0), // Space between the buttons
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

            // pictures & videos
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
                          Text(widget.hours),
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
                          Text(widget.address),
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
                          const SizedBox(width: 8.0,),
                          Text(widget.parking
                              ? "Parking available"
                              : "No Parking"),
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
                          const SizedBox(width: 8.0,),
                          Text("Contact: ${widget.contact}" ),
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
