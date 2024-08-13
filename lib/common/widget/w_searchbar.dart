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
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 10),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatbotFragment()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(2.0),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.yellow, Colors.orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(1.0), // Adjust padding as needed
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.appColors.mainWhite, // Background color for the inner container
                  ),
                  child: Image.asset(
                    'assets/image/mainLogo.png',
                    height: 45.0,
                    width: 45.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}