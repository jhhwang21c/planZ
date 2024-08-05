import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planZ/common/common.dart';
import 'package:planZ/screen/main/s_signup_four.dart';

import '../../common/widget/scaffold/w_text_field.dart';
import '../../common/widget/w_button.dart';

class SignUpPageThree extends StatefulWidget {
  final AbstractThemeColors themeColors;
  const SignUpPageThree({super.key, required this.themeColors});

  @override
  State<SignUpPageThree> createState() => _SignUpPageThreeState();
}

class _SignUpPageThreeState extends State<SignUpPageThree> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                textEditingController: emailController, hintText: 'planz@example.com',
              ),
              const Text(
                'Password',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              TextFieldInpute(
                textEditingController: passwordController, hintText: '8-12 characters',
              ),
              MyButton(
                  onTab: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpPageFour(themeColors: widget.themeColors),
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
