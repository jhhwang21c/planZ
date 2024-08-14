import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planZ/app_state.dart';
import 'package:planZ/common/common.dart';
import 'package:planZ/common/dart/extension/context_extension.dart';
import 'package:video_player/video_player.dart';

class MapView extends StatefulWidget {
  final GeoPoint? spotLocation;
  final Map<String, dynamic>? spot;
  final void Function(double)? onSheetSizeChange;

  const MapView({Key? key, this.spotLocation, this.spot, this.onSheetSizeChange}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  LocationData? _currentLocation;
  GoogleMapController? _mapController;
  double _sheetSize = 0.35;
  final DraggableScrollableController _draggableScrollableController = DraggableScrollableController();
  List<String> videoLinks = [];
  List<VideoPlayerController> _videoControllers = [];
  List<String> imageLinks = [];

  @override
  void initState() {
    super.initState();
    if (widget.spotLocation == null) {
      _fetchCurrentLocation();
    }
    fetchVideoLinks();
    fetchImageLinks();

    _draggableScrollableController.addListener(() {
      setState(() {
        _sheetSize = _draggableScrollableController.size;
        if (widget.onSheetSizeChange != null) {
          widget.onSheetSizeChange!(_sheetSize);
        }
      });
    });
  }

  void fetchVideoLinks() async {
    try {
      if (widget.spot?['id'] != null) {
        QuerySnapshot videoSnapshot = await FirebaseFirestore.instance
            .collection('video')
            .where('spot_id', isEqualTo: widget.spot?['id'])
            .get();

        List<String> links = videoSnapshot.docs
            .map((doc) => doc['video_link'] as String? ?? '')
            .toList();

        setState(() {
          videoLinks = links;
          _videoControllers = links
              .where((link) => link.isNotEmpty)
              .map((link) =>
          VideoPlayerController.network(link)
            ..initialize())
              .toList();
        });
      }
    } catch (e) {
      print('Error fetching video links: $e');
    }
  }

  void fetchImageLinks() async {
    try {
      if (widget.spot?['id'] != null) {
        QuerySnapshot imageSnapshot = await FirebaseFirestore.instance
            .collection('spot')
            .doc(widget.spot?['id'])
            .collection('image')
            .get();

        List<String> links = imageSnapshot.docs
            .map((doc) => doc['image_link'] as String? ?? '')
            .toList();

        setState(() {
          imageLinks = links;
        });
      }
    } catch (e) {
      print('Error fetching image links: $e');
    }
  }

  @override
  void dispose() {
    _draggableScrollableController.dispose();
    super.dispose();
  }

  Future<void> _fetchCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location services are enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // Check for location permissions
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Get the current location
    final currentLocation = await location.getLocation();
    setState(() {
      _currentLocation = currentLocation;
      _moveCameraToLocation(
        LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
      );
    });
  }

  void _moveCameraToLocation(LatLng target) {
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: 15.0),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentLanguage = AppLangState.instance.appLanguage;
    String spotName = widget.spot?['translated_name']?[currentLanguage]?.toString() ?? 'No Info';
    String area = widget.spot?['translated_area']?[currentLanguage]?.toString() ?? 'No Area';
    String address = widget.spot?['translated_address']?[currentLanguage]?.toString() ?? 'No Address';
    String contact = widget.spot?['contact']?.toString() ?? 'No Contact';
    String hours = widget.spot?['translated_hours']?[currentLanguage]?.toString() ?? 'hours unavailable';
    String parking = widget.spot?['parking'] == true ? 'Parking Available' : 'Parking unavailable';

    List<String> hashtags = [];
    if (widget.spot?['translated_hashtags'] != null) {
      var translatedHashtags = widget.spot?['translated_hashtags'];
      for (var i = 0; i < translatedHashtags.length; i++) {
        hashtags.add(translatedHashtags[i.toString()]?[currentLanguage] ?? '');
      }
    }
    print(imageLinks);

    return Stack(
        children: [
      GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.spotLocation != null
              ? LatLng(
                  widget.spotLocation!.latitude, widget.spotLocation!.longitude)
              : const LatLng(0, 0),
          // Default to 0,0 if current location is not yet fetched
          zoom: 15.0,
        ),
        markers: {
          if (widget.spotLocation != null)
            Marker(
              markerId: const MarkerId("spot"),
              position: LatLng(widget.spotLocation!.latitude,
                  widget.spotLocation!.longitude),
            ),
          if (_currentLocation != null)
            Marker(
              markerId: const MarkerId("current"),
              position: LatLng(
                  _currentLocation!.latitude!, _currentLocation!.longitude!),
            ),
        },
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
          if (_currentLocation != null && widget.spotLocation == null) {
            _moveCameraToLocation(
              LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
            );
          }
        },
      ),

      //bottom sheet
      if (widget.spotLocation != null)
      DraggableScrollableSheet(
          controller: _draggableScrollableController,
          maxChildSize: 1,
          initialChildSize: 0.35,
          minChildSize: 0.35,
          builder: (context, controller) {
            return Material(
              color: context.appColors.mainWhite,
              shadowColor: context.appColors.placeholder,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(14),
                topLeft: Radius.circular(14),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    if (_sheetSize < 0.8)
                      Center(
                        child: Container(
                          height: 3,
                          width: 40,
                          color: context.appColors.placeholder,
                        ),
                      ),

                    //spot detail
                    Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            controller: controller,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                // Return the Column widget for the first item
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(top: 34.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                spotName,
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
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
                                          Padding(
                                            padding: const EdgeInsets.only(top: 12.0, right: 8),
                                            child: Container(
                                              height: 20,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1.0,
                                                    color: context.appColors.mainGray),
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset('assets/image/icon/Location.svg',
                                                      width: 8,
                                                      height: 10,
                                                      color: Colors.black,
                                                    ),
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(area, style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w500, color: Colors.black,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 12.0),
                                                child: hashtags.isNotEmpty
                                                    ? Wrap(
                                                        spacing: 12.0,
                                                        children: hashtags.map((hashtag) {
                                                          return Container(
                                                            height: 20,
                                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                            decoration: BoxDecoration(
                                                              border: Border.all(width: 1.0,
                                                                  color: context.appColors.mainGray),
                                                              color: Colors.transparent,
                                                              borderRadius: BorderRadius.circular(100),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                '# $hashtag',
                                                                style: const TextStyle(
                                                                  fontSize: 10.0,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }).toList(),
                                                      )
                                                    : const Text(
                                                        'Loading hashtags...',
                                                        style: TextStyle(
                                                            fontSize: 10.0,
                                                            color: Colors.white),
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 12.0),
                                            child: Row(
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
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
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
                                                  padding: EdgeInsets.only(
                                                      right: 8.0),
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
                                          ),
                                          Icon(Icons.add)
                                        ],
                                      ),
                                      if (_sheetSize > 0.4)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () {},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.black,
                                                    backgroundColor: context
                                                        .appColors.baseGray,
                                                    // Text color
                                                    minimumSize:
                                                        const Size(0, 40),
                                                    // Width and height
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100), // Rounded corners
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.black,
                                                    backgroundColor: context
                                                        .appColors.baseGray,
                                                    // Text color
                                                    minimumSize:
                                                        const Size(0, 40),
                                                    // Width and height
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100), // Rounded corners
                                                    ), // Shadow elevation
                                                  ),
                                                  child: const Text(
                                                    "View on Map",
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                      // pictures & videos
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 20.0),
                                        child: SizedBox(
                                          height: 270.0,
                                          child: imageLinks.isEmpty && videoLinks.isEmpty
                                              ? const Center(
                                            child: Text("No images or videos available"),
                                          )
                                              : ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: [
                                              if (imageLinks.isNotEmpty)
                                                ...imageLinks.map((imageLink) => Row(
                                                  children: [
                                                    AspectRatio(
                                                      aspectRatio: 9 / 16,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(4.0), // Adjust the radius as needed
                                                        child: Image.network(
                                                          imageLink,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 24),
                                                  ],
                                                )),
                                              if (videoLinks.isNotEmpty)
                                                ..._videoControllers.map((controller) => Row(
                                                  children: [
                                                    AspectRatio(
                                                      aspectRatio: 9 / 16,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(4.0), // Border radius
                                                        child: VideoPlayer(controller),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 24),
                                                  ],
                                                )),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // 영업정보
                                      Container(
                                        child: Column(
                                          children: [
                                            SizedBox(
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
                                                    Expanded(child: Text(hours)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Divider(
                                              height: 20,
                                              thickness: 1,
                                              indent: 0,
                                              endIndent: 25,
                                              color: Color(0xFFE1E4E8),
                                            ),
                                            SizedBox(
                                              height: 40.0,
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
                                                  Expanded(child: Text(address)),
                                                ],
                                              ),
                                            ),
                                            const Divider(
                                              height: 20,
                                              thickness: 1,
                                              indent: 0,
                                              endIndent: 25,
                                              color: Color(0xFFE1E4E8),
                                            ),
                                            SizedBox(
                                              height: 40.0,
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
                                                  Text(parking),
                                                ],
                                              ),
                                            ),
                                            const Divider(
                                              height: 20,
                                              thickness: 1,
                                              indent: 0,
                                              endIndent: 25,
                                              color: Color(0xFFE1E4E8),
                                            ),
                                            SizedBox(
                                              height: 40.0,
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
                                                  Text("Contact: (+82) ${contact}"),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            })
                    )
                  ],
                ),
              ),
            );
          })
    ]);
  }
}
