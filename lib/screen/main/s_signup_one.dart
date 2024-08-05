import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planZ/common/common.dart';
import 'package:planZ/screen/main/s_signup_two.dart';

import '../../common/widget/scaffold/w_text_field.dart';
import '../../common/widget/w_button.dart';

class SignUpPageOne extends StatefulWidget {
  final AbstractThemeColors themeColors;
  const SignUpPageOne({super.key, required this.themeColors});

  @override
  State<SignUpPageOne> createState() => _SignUpPageOneState();
}

class _SignUpPageOneState extends State<SignUpPageOne> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

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
                width: 198,
                height: 80,
                child: Text(
                  'Tell us about who you are.',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 4.0, bottom: 24),
                child: Text(
                  "This won't be displayed on your page.",
                  style: TextStyle(),
                ),
              ),
              const Text(
                'First Name',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              TextFieldInpute(
                textEditingController: firstNameController, hintText: 'Your first name',
              ),
              const Text(
                'Last Name',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              TextFieldInpute(
                textEditingController: lastNameController, hintText: 'Your last name',
              ),
              MyButton(
                  onTab: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpPageTwo(themeColors: widget.themeColors),
                      ),
                    );
                  },
                  text: "Next"),
            ],
          ),
        ),
      ),
    );
  }
}
