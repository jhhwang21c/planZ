import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planZ/common/common.dart';
import 'package:planZ/screen/main/authentication.dart';
import 'package:planZ/screen/main/s_login.dart';
import 'package:planZ/screen/main/s_main.dart';

import '../../common/widget/scaffold/w_text_field.dart';

class SignUpPageFour extends StatefulWidget {
  final AbstractThemeColors themeColors;
  final String firstName;
  final String lastName;
  final String birthday;
  final String gender;
  final String email;
  final String uid;

  const SignUpPageFour(
      {super.key,
      required this.themeColors,
      required this.firstName,
      required this.lastName,
      required this.birthday,
      required this.gender,
      required this.email,
      required this.uid,});

  @override
  State<SignUpPageFour> createState() => _SignUpPageFourState();
}

class _SignUpPageFourState extends State<SignUpPageFour> {
  final TextEditingController usernameController = TextEditingController();
  final AuthServicews _authService = AuthServicews();


  void _completeSignUp() async {
    await _authService.updateUserProfile(
      uid: widget.uid,
      data: {
        'username': usernameController.text,
      },
    );

    // Navigate to the MainScreen or wherever appropriate
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(themeColors: widget.themeColors),
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
                textEditingController: usernameController,
                hintText: 'your username',
              ),
              ElevatedButton(onPressed: _completeSignUp, child: Text('Done!'))
            ],
          ),
        ),
      ),
    );
  }
}
