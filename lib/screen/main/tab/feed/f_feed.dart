import 'package:flutter/material.dart';
import 'package:planZ/common/common.dart';
import 'package:planZ/screen/main/tab/feed/f_card_list.dart';
import 'package:planZ/screen/main/tab/feed/f_card_list_detail.dart';

class FeedFragment extends StatefulWidget {
  const FeedFragment({super.key});

  @override
  State<FeedFragment> createState() => _FeedFragmentState();
}

class _FeedFragmentState extends State<FeedFragment> {
  List<String> labels = ['Discovery', 'Following'];
  final List _posts = ['post1', 'post2', 'post3', 'post4', 'post5'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: labels.length,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              height: 40.0,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(width: 0.8),
                  ),
                  // hintText: 'Search for a Journey',
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 20.0,
                  ),
                  // suffixIcon: IconButton(
                  //   icon: Icon(Icons.clear),
                  //   onPressed: () {},
                  // ),
                ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Container(
              height: 28.0,
              child: TabBar(
                tabs: labels.map((label) {
                  return Container(
                    width: 160.0,
                    child: Tab(text: label),
                  );
                }).toList(),
                indicator: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: labels.map((label) {
                  // return Center(child: Text('Content for $label'));
                  return ListView.builder(
                      itemCount: _posts.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CardListDetail(title: _posts[index]),
                                ),
                              );
                            },
                            child: CardList(postTitle: _posts[index]),
                        );
                      });
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
