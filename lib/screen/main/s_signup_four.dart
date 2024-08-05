import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planZ/common/common.dart';
import 'package:planZ/screen/main/s_main.dart';

import '../../common/widget/scaffold/w_text_field.dart';
import '../../common/widget/w_button.dart';

class SignUpPageFour extends StatefulWidget {
  final AbstractThemeColors themeColors;
  const SignUpPageFour({super.key, required this.themeColors});

  @override
  State<SignUpPageFour> createState() => _SignUpPageFourState();
}

class _SignUpPageFourState extends State<SignUpPageFour> {
  final TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 131,
              ),
              const SizedBox(
                width: 283,
                child: Text(
                  'Choose a username for your account.',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const Text(
                'Username',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              TextFieldInpute(
                textEditingController: usernameController, hintText: 'yourusername',
              ),
              MyButton(
                  onTab: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreen(themeColors: widget.themeColors),
                      ),
                    );
                  },
                  text: "Done!"),
            ],
          ),
        ),
      ),
    );
  }
}
