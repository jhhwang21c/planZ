import 'package:flutter/material.dart';
import 'package:planZ/common/dart/extension/context_extension.dart';
import 'package:video_player/video_player.dart';

class ToggleBarWidget extends StatefulWidget {
  final List<String> labels;
  final TabController tabController;

  VideoPlayerController? videoPlayerController;

  ToggleBarWidget({
    required this.labels,
    required this.tabController,
    this.videoPlayerController
  });

  @override
  State<ToggleBarWidget> createState() => _ToggleBarWidgetState();
}

class _ToggleBarWidgetState extends State<ToggleBarWidget> {

  void _onTabTapped(int index) {
    if (widget.videoPlayerController != null) {
      if (widget.videoPlayerController!.value.isPlaying) {
        widget.videoPlayerController?.pause();
      } else {
        widget.videoPlayerController?.play();
      }
    }
    widget.tabController.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 40.0,
          width: 242.0, // Adjust the height as needed
          decoration: BoxDecoration(
            color: context.appColors.grayFillQuartOp,
            borderRadius: BorderRadius.circular(100),
          ),
          child: TabBar(
            dividerColor: Colors.transparent,
            controller: widget.tabController,
            onTap: _onTabTapped,
            tabs: widget.labels.map((label) {
              return SizedBox( // Adjust the width as needed
                child: Tab(text: label),
              );
            }).toList(),
            indicator: BoxDecoration(
              color: context.appColors.mainBlack,
              borderRadius: BorderRadius.circular(100),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
            labelColor: Colors.white,
            unselectedLabelColor: context.appColors.mainBlack,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
