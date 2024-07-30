// import 'package:flutter/material.dart';
// import 'package:planZ/common/common.dart';
// import 'package:planZ/screen/main/tab/feed/f_card_list.dart';
// import 'package:planZ/screen/main/tab/feed/f_card_list_detail.dart';
//
// class FeedFragment extends StatefulWidget {
//   const FeedFragment({super.key});
//
//   @override
//   State<FeedFragment> createState() => _FeedFragmentState();
// }
//
// class _FeedFragmentState extends State<FeedFragment> with SingleTickerProviderStateMixin{
//   List<String> labels = ['Discovery', 'Following'];
//   final List _posts = ['post1', 'post2', 'post3', 'post4', 'post5'];
//
//   late PageController _pageController;
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//     _tabController = TabController(length: labels.length, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   void _onTabTapped(int index) {
//     _pageController.jumpToPage(index);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: labels.length,
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
//               height: 64.0,
//               child: TextField(
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20.0),
//                     borderSide: const BorderSide(width: 0.8),
//                   ),
//                   prefixIcon: const Icon(
//                     Icons.search,
//                     size: 20.0,
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               height: 28.0,
//               child: TabBar(
//                 tabs: labels.map((label) {
//                   return Container(
//                     width: 160.0,
//                     child: Tab(text: label),
//                   );
//                 }).toList(),
//                 indicator: BoxDecoration(
//                   color: Colors.grey,
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 indicatorSize: TabBarIndicatorSize.tab,
//                 labelColor: Colors.black,
//                 unselectedLabelColor: Colors.black,
//                 labelStyle: const TextStyle(fontWeight: FontWeight.bold),
//                 unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
//               ),
//             ),
//             Expanded(
//               child: PageView(
//                 controller: _pageController,
//                 physics: const NeverScrollableScrollPhysics(),
//                 children: labels.map((label) {
//                   // return Center(child: Text('Content for $label'));
//                   return ListView.builder(
//                       itemCount: _posts.length,
//                       itemBuilder: (context, index) {
//                         return InkWell(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       CardListDetail(title: _posts[index]),
//                                 ),
//                               );
//                             },
//                             child: CardList(postTitle: _posts[index]),
//                         );
//                       });
//                 }).toList(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:planZ/screen/main/tab/feed/f_card_list.dart';
import 'package:planZ/screen/main/tab/feed/f_card_list_detail.dart';

class FeedFragment extends StatefulWidget {
  const FeedFragment({super.key});

  @override
  State<FeedFragment> createState() => _FeedFragmentState();
}

class _FeedFragmentState extends State<FeedFragment> with SingleTickerProviderStateMixin {
  List<String> labels = ['Discovery', 'Following'];
  final List _posts = ['post1', 'post2', 'post3', 'post4', 'post5'];

  late PageController _pageController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabController = TabController(length: labels.length, vsync: this);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            height: 64.0,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(width: 0.8),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 20.0,
                ),
              ),
            ),
          ),
          Expanded(child: Stack(children: [
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: labels.map((label) {
                return ListView.builder(
                  itemCount: _posts.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CardListDetail(title: _posts[index]),
                          ),
                        );
                      },
                      child: CardList(postTitle: _posts[index]),
                    );
                  },
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 43.0, vertical: 10.0),
              child: Container(
                height: 28.0,
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: TabBar(
                  controller: _tabController,
                  onTap: _onTabTapped,
                  tabs: labels.map((label) {
                    return SizedBox(
                      width: 160.0,
                      child: Tab(text: label),
                    );
                  }).toList(),
                  indicator: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  labelStyle: const TextStyle(fontWeight: FontWeight.normal),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ),
            ),
          ],)
          )
        ],
      ),
    );
  }
}
