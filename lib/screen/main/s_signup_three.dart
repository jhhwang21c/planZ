import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planZ/common/common.dart';
import 'package:planZ/screen/main/authentication.dart';
import 'package:planZ/screen/main/s_signup_four.dart';

import '../../common/widget/scaffold/w_text_field.dart';

class SignUpPageThree extends StatefulWidget {
  final AbstractThemeColors themeColors;
  final String firstName;
  final String lastName;
  final String birthday;
  final String gender;

  const SignUpPageThree(
      {super.key,
      required this.themeColors,
      required this.firstName,
      required this.lastName,
      required this.birthday,
      required this.gender});

  @override
  State<SignUpPageThree> createState() => _SignUpPageThreeState();
}

class _SignUpPageThreeState extends State<SignUpPageThree> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthServicews _authService = AuthServicews();

  void _goToNextPage() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email and password cannot be empty")),
      );
      return;
    }

    if (passwordController.text.length < 8 || passwordController.text.length > 12) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password must be 8-12 characters long")),
      );
      return;
    }

    User? user = await _authService.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );

    if (user != null) {
      // Create initial profile in Firestore
      await _authService.createUserProfile(
        uid: user.uid,
        data: {
          'first_name': widget.firstName,
          'last_name': widget.lastName,
          'birthday': widget.birthday,
          'gender': widget.gender,
          'email': emailController.text,
        },
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignUpPageFour(
            themeColors: widget.themeColors,
            firstName: widget.firstName,
            lastName: widget.lastName,
            birthday: widget.birthday,
            gender: widget.gender,
            email: emailController.text,
            uid: user.uid,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create account")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
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
                  'Set an email and password for your account.',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const Text(
                'Email',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              TextFieldInpute(
                textEditingController: emailController,
                hintText: 'planz@example.com',
              ),
              const Text(
                'Password',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              TextFieldInpute(
                textEditingController: passwordController,
                hintText: '8-12 characters',
              ),
              ElevatedButton(onPressed: _goToNextPage, child: Text('Next'))
            ],
          ),
        ),
      ),
    );
  }
}
