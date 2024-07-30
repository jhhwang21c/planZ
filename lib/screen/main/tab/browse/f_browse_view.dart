import 'package:flutter/material.dart';
import 'package:planZ/screen/main/tab/browse/f_browse_video.dart';


class BrowseView extends StatefulWidget {
  @override
  State<BrowseView> createState() => _BrowseViewState();
}

class _BrowseViewState extends State<BrowseView> {
  final List<String> _vids = ['vid1', 'vid2', 'vid3', 'vid4', 'vid5', 'vid6'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 64.0),
      child: GridView.builder(
        itemCount: _vids.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 9 / 16,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BrowseVideo(video: _vids[index]),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: Container(
                  height: 50,
                  width: 50,
                  color: Colors.blue,
                  child: Center(
                    child: Text(
                      _vids[index],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}