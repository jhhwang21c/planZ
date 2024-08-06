import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:planZ/common/common.dart';

class SpotDetail extends StatefulWidget {
  final String spotName;
  final String address;
  final String contact;
  final String hours;
  final bool parking;
  final List<String> imageLinks;
  List<dynamic>? hashtags;

  SpotDetail({
    required this.spotName,
    required this.address,
    required this.contact,
    required this.hours,
    required this.parking,
    required this.hashtags,
    required this.imageLinks,
  });

  @override
  State<SpotDetail> createState() => _SpotDetailState();
}

class _SpotDetailState extends State<SpotDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: <Widget>[
            Container(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.spotName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/image/icon/Save.svg',
                      width: 24.0,
                      height: 24.0,
                    ),
                  ],
                )),

            Container(
              child: Align(
                alignment: Alignment.centerLeft,
                child: widget.hashtags != null
                    ? Wrap(
                        spacing: 8.0,
                        children: widget.hashtags!.map((hashtag) {
                          return Text(
                            '# $hashtag',
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black, // You can change the color if needed
                            ),
                          );
                        }).toList(),
                      )
                    : const Text(
                        'Loading hashtags...',
                        style: TextStyle(fontSize: 12.0),
                      ),
              ),
            ),

            Row(
              children: [
                SvgPicture.asset(
                  'assets/image/icon/Car.svg',
                  width: 12.0,
                  height: 12.0,
                ),
                const SizedBox(
                  width: 4.0,
                ),
                const Text(
                  "4 min",
                  style: TextStyle(fontSize: 13),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SvgPicture.asset(
                    'assets/image/icon/Transit.svg',
                    width: 14.0,
                    height: 14.0,
                  ),
                ),
                const SizedBox(
                  width: 4.0,
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text("4 min"),
                ),
                SvgPicture.asset(
                  'assets/image/icon/Walk.svg',
                  width: 14.0,
                  height: 14.0,
                ),
                const SizedBox(
                  width: 4.0,
                ),
                const Text("15 min"),
              ],
            ),

            //buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.grey,
                          // Text color
                          minimumSize: const Size(0, 40),
                          // Width and height
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(100), // Rounded corners
                          ), // Shadow elevation
                        ),
                        child: const Text(
                          "Reserve",
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.grey,
                          // Text color
                          minimumSize: const Size(0, 40),
                          // Width and height
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(100), // Rounded corners
                          ), // Shadow elevation
                        ),
                        child: const Text(
                          "Add to Plan",
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // pictures & videos
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                height: 270.0,
                child: widget.imageLinks.isEmpty
                ? const Center(
                  child: Text("No images available"),
                )
                : ListView.builder(
                  itemCount: widget.imageLinks.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Row(children: [
                        AspectRatio(
                            aspectRatio: 9 / 16,
                            child: Image.network(
                              widget.imageLinks[index],
                              fit: BoxFit.cover,
                            ),
                        ),
                      const SizedBox(
                        width: 24,
                      )
                    ]);
                  },
                ),
              ),
            ),

            // 영업정보
            Container(
              child: Column(
                children: [
                  SizedBox(
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/image/icon/Clock.svg',
                              width: 14.0,
                              height: 14.0,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Expanded(child: Text(widget.hours)),
                          ],
                        ),
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
                          const SizedBox(
                            width: 8.0,
                          ),
                          Expanded(child: Text(widget.address)),
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
                          const SizedBox(
                            width: 8.0,
                          ),
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
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text("Contact: (+82) ${widget.contact}"),
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
