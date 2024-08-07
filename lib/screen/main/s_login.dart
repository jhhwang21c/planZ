import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planZ/common/common.dart';
import 'package:planZ/screen/main/authentication.dart';
import 'package:planZ/screen/main/s_main.dart';
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
  final AuthServicews _authService = AuthServicews();

  void _login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email and password cannot be empty')));
      return;
    }

    User? user = await _authService.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(themeColors: widget.themeColors),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Incorrect email or password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 131,
                        ),
                        Center(
                          child: Image.asset(
                            'assets/image/splash/loginLogo.png',
                            width: 80,
                            height: 131,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Email',
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                        TextFieldInpute(
                          textEditingController: emailController,
                          hintText: '',
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Password',
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                        TextFieldInpute(
                          textEditingController: passwordController,
                          hintText: '',
                          isObscure: true,
                        ),
                        const SizedBox(height: 16),
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
                        const SizedBox(height: 16),
                        ElevatedButton(onPressed: _login, child: const Text('Log In')),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Not a member?  ",
                              style: TextStyle(fontSize: 16),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SignUpPageOne(themeColors: widget.themeColors),
                                  ),
                                );
                              },
                              child: const Text(
                                'Sign up',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(), // Add spacer to push the content up and avoid overflow
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}