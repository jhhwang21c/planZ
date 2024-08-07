import 'package:flutter/material.dart';
import 'package:planZ/common/common.dart';
import 'package:planZ/screen/main/tab/chatbot/f_chat.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 12.0),
              height: 60.0,
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: context.appColors.mainWhite,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.0),
                    borderSide: BorderSide(
                      color: context.appColors.baseGray,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.0),
                    borderSide: BorderSide(
                      color: context.appColors.mainGray,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 24.0,
                    color: context.appColors.mainGray,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.chat,
              color: context.appColors.mainGray,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatbotFragment()),
              );
            },
          ),
        ],
      ),
    );
  }
}