import 'package:flutter/material.dart';

class CardList extends StatelessWidget {
  final String postTitle;

  CardList({required this.postTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60.0),
      child: Container(
        // color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 163.0,
              color: Colors.grey,
            ),
            Container(
              height: 104.0,
              // child: Text(
              //   postTitle,
              // ),
              child: Column(
                children: [
                  const Row(
                    children:
                    <Widget>[
                      Text('Title',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),),
                    ],
                  ),
                  const Row(
                    children: <Widget>[
                      Text('#Hashtag'),
                    ],
                  ),
                  Text(postTitle)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
