import 'package:flutter/material.dart';
import 'package:planZ/common/common.dart';
import 'package:planZ/common/dart/extension/context_extension.dart';
import 'package:planZ/common/widget/w_searchbar.dart';
import 'package:planZ/screen/main/tab/browse/f_map_view.dart';
import 'package:planZ/screen/main/tab/plan/f_plan_mapview.dart';
import 'package:planZ/screen/main/tab/plan/f_saves.dart';
import 'package:planZ/screen/main/tab/plan/f_trips.dart';
import 'global.dart';

class PlanFragment extends StatefulWidget {
  const PlanFragment({super.key});

  @override
  State<PlanFragment> createState() => _PlanFragmentState();
}

class _PlanFragmentState extends State<PlanFragment> {
  double _sheetSize = 0.35;
  bool isLongPressed = false;
  final DraggableScrollableController _draggableScrollableController =
  DraggableScrollableController();

  @override
  void initState() {
    super.initState();

    _draggableScrollableController.addListener(() {
      setState(() {
        _sheetSize = _draggableScrollableController.size;
      });
    });
  }

  @override
  void dispose() {
    _draggableScrollableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 250.0),
            child: PlanMapView(locations: selectedLocations),
          ),
          SearchBarWidget(),
          DraggableScrollableSheet(
              controller: _draggableScrollableController,
              maxChildSize: 0.7,
              initialChildSize: 0.4,
              minChildSize: 0.1,
              builder: (context, controller) {
                return Material(
                  color: context.appColors.mainWhite,
                  shadowColor: context.appColors.placeholder,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(14),
                    topLeft: Radius.circular(14),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 16,),
                        Center(
                          child: Container(
                            height: 3,
                            width: 40,
                            color: context.appColors.placeholder,
                          ),
                        ),
                        const SizedBox(height: 16,),

                        if (selectedSpots.isNotEmpty)
                          Expanded(
                            child: ReorderableListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: selectedSpots.length + 1, // Increment item count by 1 for the additional image
                              onReorder: (int oldIndex, int newIndex) {
                                setState(() {
                                  if (newIndex > oldIndex) {
                                    newIndex -= 1;
                                  }
                                  if (oldIndex < selectedSpots.length) { // Ensure only spots are reordered
                                    final spot = selectedSpots.removeAt(oldIndex);
                                    selectedSpots.insert(newIndex, spot);
                                  }
                                });
                              },
                              itemBuilder: (context, index) {
                                if (index == selectedSpots.length) {
                                  // This is the extra image container next to the last selected spot
                                  return Container(
                                    key: ValueKey('add_button'), // Unique key for this extra image
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 72,
                                      height: 72,
                                      child: SvgPicture.asset('assets/image/icon/planAdd.svg'),
                                    ),
                                  );
                                } else {
                                  // Original selected spots
                                  final spot = selectedSpots[index];
                                  return Container(
                                    key: ValueKey(spot['spotName']),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 72,
                                      height: 72,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(spot['imageUrl']!),
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                            context.appColors.mainBlack.withOpacity(0.8),
                                            BlendMode.darken,
                                          ),
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 8,
                                            left: 8,
                                            child: Text(
                                              '${index + 1}',
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
                                            right: 8,
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
                                  );
                                }
                              },
                            ),
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

                        //mysaves
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

                              // if (result != null) {
                              //   setState(() {
                              //   });
                              // }
                              if (result != null && result is List<Map<String, dynamic>>) {
                                setState(() {
                                  selectedLocations = result; // Update selectedLocations with the result from MySaves
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
                        const SizedBox(height: 20,)
                      ],
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}