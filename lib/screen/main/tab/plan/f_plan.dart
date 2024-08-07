import 'package:flutter/material.dart';
import 'package:planZ/common/common.dart';
import 'package:planZ/common/widget/w_searchbar.dart';
import 'package:planZ/screen/main/tab/browse/f_map_view.dart';

class PlanFragment extends StatefulWidget {
  const PlanFragment({super.key});

  @override
  State<PlanFragment> createState() => _PlanFragmentState();
}

class _PlanFragmentState extends State<PlanFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const MapView(),
          SearchBarWidget(),
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.1,
            maxChildSize: 0.5,
            builder: ( context,  scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: context.appColors.mainWhite,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFE1E4E8),
                        blurRadius: 1,
                        spreadRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(22), topRight: Radius.circular(22))
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SvgPicture.asset('assets/image/icon/planAdd.svg', width: 72, height: 72,),
                      const Divider(
                        height: 20,
                        thickness: 1,
                        indent: 0,
                        endIndent: 25,
                        color: Colors.black26,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
Text('My trips')
                          ],
                        ),
                      ),
                      const Divider(
                        height: 20,
                        thickness: 1,
                        indent: 0,
                        endIndent: 25,
                        color: Colors.black26,
                      ),
                    ],
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