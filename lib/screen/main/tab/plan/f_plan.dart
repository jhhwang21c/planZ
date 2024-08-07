import 'package:flutter/material.dart';
import 'package:planZ/common/common.dart';
import 'package:planZ/common/widget/w_searchbar.dart';
import 'package:planZ/screen/main/tab/browse/f_map_view.dart';

class PlanFragment extends StatefulWidget {
  const PlanFragment({super.key});

  get child => null;

  @override
  State<PlanFragment> createState() => _PlanFragmentState();
}

class _PlanFragmentState extends State<PlanFragment> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapView(),
        SearchBarWidget(),
        DraggableSheet(child: SizedBox(
          height: 100,

        )
        )
      ],
    );
  }
}
class DraggableSheet extends StatefulWidget {
  final Widget child;
  const DraggableSheet({super.key, required this.child});

  @override
  State<DraggableSheet> createState() => _DraggableSheetState();
}

class _DraggableSheetState extends State<DraggableSheet> {
  @override
  Widget build(BuildContext context) {
    final sheet = GlobalKey();
    final controller = DraggableScrollableController();

    return LayoutBuilder(builder: (builder, constraints) {
      return DraggableScrollableSheet(
          key: sheet,
          initialChildSize: MediaQuery.,
          maxChildSize: 0.5,
          minChildSize: 0,
          expand: true,
          snap: true,
          snapSizes: [
            60/ constraints.maxHeight,
            0.5,
          ],
          builder: (BuildContext context, ScrollController scrollController) {
            return DecoratedBox(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xFFE1E4E8),
                        blurRadius: 1,
                        spreadRadius: 1,
                        offset: Offset(0, 1))
                  ],
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(22),
                      topLeft: Radius.circular(22))),
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: widget.child,
                  )
                ],
              ),
            );
          });
    });
  }
}

