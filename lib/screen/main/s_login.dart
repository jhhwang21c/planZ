import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:planZ/common/common.dart';
import 'package:planZ/common/widget/w_button.dart';
import 'package:planZ/screen/main/s_signup_one.dart';

import '../../common/widget/scaffold/w_text_field.dart';

class LoginPage extends StatefulWidget {
  final AbstractThemeColors themeColors;

  const LoginPage({super.key, required this.themeColors});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 131,),
            Center(
              child: Image.asset(
                'assets/image/splash/loginLogo.png',
                width: 80,
                height: 131,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0,),
              child: Text('Email',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16
                ),
              ),
            ),
            TextFieldInpute(
              textEditingController: emailController, hintText: '',),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0,),
              child: Text('Password',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16
                ),
              ),
            ),
            TextFieldInpute(
              textEditingController: passwordController, hintText: '',),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
            MyButton(onTab: () {}, text: "Log In"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Not a member?  ",
                  style: TextStyle(
                      fontSize: 16
                  ),),
                GestureDetector(onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>  SignUpPageOne(themeColors: widget.themeColors),
                      ),
                  );
                },
                  child: const Text('Sign up',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),),
                )
              ],
            )
          ],
        ),
      ),

      ),
    );
  }
}
