// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:planZ/common/common.dart';
// import 'package:planZ/common/widget/w_searchbar.dart';
// import 'package:planZ/screen/main/tab/browse/f_browse.dart';
// import 'package:planZ/screen/main/tab/browse/f_map_view.dart';
// import 'package:planZ/screen/main/tab/plan/f_saves.dart';
// import 'package:planZ/screen/main/tab/plan/f_trips.dart';
//
// import 'global.dart';
//
// class PlanTwo extends StatefulWidget {
//   const PlanTwo({super.key});
//
//   @override
//   State<PlanTwo> createState() => _PlanTwoState();
// }
//
// class _PlanTwoState extends State<PlanTwo> {
//   bool isLongPressed = false;
//   int? selectedIndex;
//
//   // Reorder method
//   void updateMyTiles(int oldIndex, int newIndex) {
//     setState(() {
//       if (newIndex > oldIndex) {
//         newIndex -= 1;
//       }
//       final tile = selectedSpots.removeAt(oldIndex);
//       selectedSpots.insert(newIndex, tile);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           const MapView(),
//           SearchBarWidget(),
//           DraggableScrollableSheet(
//             initialChildSize: 0.4,
//             minChildSize: 0.1,
//             maxChildSize: 0.5,
//             builder: (context, scrollController) {
//               return Container(
//                 decoration: BoxDecoration(
//                     color: context.appColors.mainWhite,
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Color(0xFFE1E4E8),
//                         blurRadius: 1,
//                         spreadRadius: 1,
//                         offset: Offset(0, 1),
//                       ),
//                     ],
//                     borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(22),
//                         topRight: Radius.circular(22))),
//                 child: SingleChildScrollView(
//                   controller: scrollController,
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 24),
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(top: 49.0, bottom: 40),
//                           child: Column(
//                             children: [
//                               Row(
//                                 children: [
//                                   if (selectedSpots.isNotEmpty)
//                                     Expanded(
//                                       child: Container(
//                                         height: 72,
//                                         child: ReorderableListView(
//                                           scrollDirection: Axis.horizontal,
//                                           onReorder: updateMyTiles,
//                                           children: selectedSpots.asMap().entries.map((entry) {
//                                             int index = entry.key;
//                                             var spot = entry.value;
//
//                                             return Padding(
//                                               key: ValueKey(spot),
//                                               padding: const EdgeInsets.only(right: 8.0),
//                                               child: GestureDetector(
//                                                 onLongPress: () {
//                                                   setState(() {
//                                                     isLongPressed = true;
//                                                     selectedIndex = index;
//                                                   });
//                                                 },
//                                                 onLongPressUp: () {
//                                                   setState(() {
//                                                     isLongPressed = false;
//                                                     selectedIndex = null;
//                                                   });
//                                                 },
//                                               ),
//                                               child: Container(
//                                                 width: 72,
//                                                 height: 72,
//                                                 decoration: BoxDecoration(
//                                                   image: DecorationImage(
//                                                     image: NetworkImage(spot['imageUrl']!),
//                                                     fit: BoxFit.cover,
//                                                     colorFilter: ColorFilter.mode(
//                                                       selectedIndex == index
//                                                           ? context.appColors.placeholder.withOpacity(0.8)
//                                                           : context.appColors.mainBlack.withOpacity(0.8),
//                                                       BlendMode.darken,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             );
//                                           }).toList(),
//                                         ),
//                                       ),
//                                     ),
//                                   if (selectedSpots.isNotEmpty)
//                                     isLongPressed
//                                         ? Padding(
//                                       padding: const EdgeInsets.only(left: 8.0),
//                                       child: SvgPicture.asset(
//                                         'assets/image/icon/planDelete.svg',
//                                         width: 72,
//                                         height: 72,
//                                       ),
//                                     )
//                                         : Padding(
//                                       padding: const EdgeInsets.only(left: 8.0),
//                                       child: InkWell(
//                                           onTap: () async {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) => const BrowseFragment(),
//                                               ),
//                                             );
//                                           },
//                                           child: SvgPicture.asset(
//                                             'assets/image/icon/planAdd.svg',
//                                             width: 72,
//                                             height: 72,
//                                           )),
//                                     ),
//                                   if (selectedSpots.isEmpty)
//                                     Expanded(
//                                       child: Center(
//                                         child: InkWell(
//                                           onTap: () async {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) => const BrowseFragment(),
//                                               ),
//                                             );
//                                           },
//                                           child: SvgPicture.asset(
//                                             'assets/image/icon/planAdd.svg',
//                                             width: 72,
//                                             height: 72,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                               if (selectedSpots.isNotEmpty)
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 36),
//                                   child: Container(
//                                     height: 32,
//                                     width: 93,
//                                     decoration: BoxDecoration(
//                                         color: context.appColors.baseGray,
//                                         borderRadius: BorderRadius.circular(100)),
//                                     child: Center(
//                                       child: Text(
//                                         'Confirm',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w500,
//                                             fontSize: 14,
//                                             color: context.appColors.mainBlack),
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                             ],
//                           ),
//                         ),
//                         const Divider(
//                           height: 20,
//                           thickness: 1,
//                           color: Color(0xFFE1E4E8),
//                         ),
//                         // My trips
//                         Padding(
//                           padding: EdgeInsets.symmetric(vertical: 10.0),
//                           child: InkWell(
//                             onTap: () async {
//                               await Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => MyTrips(),
//                                 ),
//                               );
//                             },
//                             child: const Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'My trips',
//                                   style: TextStyle(
//                                       fontSize: 18, fontWeight: FontWeight.w400),
//                                 ),
//                                 Icon(Icons.arrow_forward_ios),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const Divider(
//                           height: 20,
//                           thickness: 1,
//                           color: Color(0xFFE1E4E8),
//                         ),
//                         // My saves
//                         Padding(
//                           padding: EdgeInsets.symmetric(vertical: 10.0),
//                           child: InkWell(
//                             onTap: () async {
//                               final result = await Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => MySaves(),
//                                 ),
//                               );
//
//                               if (result != null) {
//                                 setState(() {});
//                               }
//                             },
//                             child: const Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'My saves',
//                                   style: TextStyle(
//                                       fontSize: 18, fontWeight: FontWeight.w400),
//                                 ),
//                                 Icon(Icons.arrow_forward_ios),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
// //
// // child: Stack(
// // children: [
// // Positioned(
// // top: 8,
// // left: 8,
// // child: Text(
// // '${index + 1}',
// // style: TextStyle(
// // fontSize: 10,
// // fontWeight: FontWeight.bold,
// // color: context.appColors.mainWhite,
// // ),
// // ),
// // ),
// // Positioned(
// // bottom: 6,
// // left: 8,
// // right: 8,
// // child: Text(
// // spot['spotName']!,
// // overflow: TextOverflow.ellipsis,
// // style: TextStyle(
// // fontSize: 10,
// // fontWeight: FontWeight.bold,
// // color: context.appColors.mainWhite,
// // ),
// // ),
// // ),
// // ],
// // ),

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:planZ/common/common.dart';
import 'package:planZ/common/widget/w_searchbar.dart';
import 'package:planZ/screen/main/tab/browse/f_map_view.dart';
import 'package:planZ/screen/main/tab/plan/f_saves.dart';
import 'package:planZ/screen/main/tab/plan/f_trips.dart';

import 'global.dart';

class PlanTwo extends StatefulWidget {
  const PlanTwo({super.key});

  @override
  State<PlanTwo> createState() => _PlanTwoState();
}

class _PlanTwoState extends State<PlanTwo> {
  bool isLongPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const MapView(),
          SearchBarWidget(),
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.1,
            maxChildSize: 0.5,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                    color: context.appColors.mainWhite,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFE1E4E8),
                        blurRadius: 1,
                        spreadRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(22),
                        topRight: Radius.circular(22))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(top: 49.0, bottom: 40),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  //display selected spots
                                  if (selectedSpots.isNotEmpty)
                                    ...selectedSpots.asMap().entries.map((entry) {
                                      int index = entry.key + 1;
                                      var spot = entry.value;

                                      return Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        //each spot
                                        child: GestureDetector(
                                          onLongPress: () {
                                            setState(() {
                                              isLongPressed = true;
                                            });
                                          },
                                          onLongPressUp: () {
                                            setState(() {
                                              isLongPressed = false;
                                            });
                                          },
                                          child: Container(
                                            width: 72,
                                            height: 72,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(spot['imageUrl']!),
                                                fit: BoxFit.cover,
                                                colorFilter: ColorFilter.mode(
                                                    isLongPressed
                                                        ? context.appColors.placeholder.withOpacity(0.8)
                                                        : context.appColors.mainBlack.withOpacity(0.8),
                                                    BlendMode.darken
                                                ),
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  top: 8,
                                                  left: 8,
                                                  child: Text('$index',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                      color: context.appColors.mainWhite,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 6,
                                                  left: 8,
                                                  right: 8, // Ensure the text stays within bounds
                                                  child: Text(
                                                    spot['spotName']!,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                      color: context.appColors.mainWhite,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  if (selectedSpots.isNotEmpty)
                                    isLongPressed ? Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: SvgPicture.asset(
                                        'assets/image/icon/planDelete.svg',
                                        width: 72,
                                        height: 72,
                                      ),
                                    ) : Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: SvgPicture.asset(
                                        'assets/image/icon/planAdd.svg',
                                        width: 72,
                                        height: 72,
                                      ),
                                    ),

                                  if (selectedSpots.isEmpty)
                                    Expanded(
                                      child: Center(
                                        child: SvgPicture.asset(
                                          'assets/image/icon/planAdd.svg',
                                          width: 72,
                                          height: 72,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              if (selectedSpots.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 36),
                                  child: Container(
                                    height: 32,
                                    width: 93,
                                    decoration: BoxDecoration(
                                        color: context.appColors.baseGray,
                                        borderRadius: BorderRadius.circular(100)
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Confirm',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: context.appColors.mainBlack
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),

                        const Divider(
                          height: 20,
                          thickness: 1,
                          color: Color(0xFFE1E4E8),
                        ),

                        //My trips
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: InkWell(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyTrips(),
                                ),
                              );
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'My trips',
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w400),
                                ),
                                Icon(Icons.arrow_forward_ios),
                              ],
                            ),
                          ),
                        ),
                        const Divider(
                          height: 20,
                          thickness: 1,
                          color: Color(0xFFE1E4E8),
                        ),


                        //my saves
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: InkWell(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MySaves(),
                                ),
                              );

                              if (result != null) {
                                setState(() {
                                });
                              }
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'My saves',
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w400),
                                ),
                                Icon(Icons.arrow_forward_ios),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}