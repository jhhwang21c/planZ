import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planZ/common/common.dart';
import 'package:planZ/screen/main/authentication.dart';
import 'package:planZ/screen/main/s_signup_three.dart';

import '../../common/widget/scaffold/w_text_field.dart';
import '../../common/widget/w_button.dart';

class SignUpPageTwo extends StatefulWidget {
  final AbstractThemeColors themeColors;
  final String firstName;
  final String lastName;

  const SignUpPageTwo(
      {super.key,
      required this.themeColors,
      required this.firstName,
      required this.lastName});

  @override
  State<SignUpPageTwo> createState() => _SignUpPageTwoState();
}

class _SignUpPageTwoState extends State<SignUpPageTwo> {
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  void _goToNextPage() async {
    // Store the first name, last name, birthday, and gender temporarily
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpPageThree(
          themeColors: widget.themeColors,
          firstName: widget.firstName,
          lastName: widget.lastName,
          birthday: birthdayController.text,
          gender: genderController.text,
        ),
      ),
    );
  }

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
                textEditingController: birthdayController,
                hintText: 'DD/MM/YYYY',
              ),
              const Text(
                'Last Name',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              TextFieldInpute(
                textEditingController: genderController,
                hintText: 'Gender',
              ),
              ElevatedButton(
                onPressed: _goToNextPage,
                child: Text("Next"),
              ),
              // MyButton(
              //     onTab: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) =>
              //               SignUpPageThree(themeColors: widget.themeColors),
              //         ),
              //       );
              //     },
              //     text: "Next"),
            ],
          ),
        ),
      ),
    );
  }
}
