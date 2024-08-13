import 'package:flutter/material.dart';
import 'package:planZ/common/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:planZ/app_state.dart';
import 'package:planZ/screen/main/s_login.dart';

class SettingsFragment extends StatefulWidget {
  final AbstractThemeColors themeColors;

  const SettingsFragment({super.key, required this.themeColors});

  @override
  State<SettingsFragment> createState() => _SettingsFragmentState();
}

class _SettingsFragmentState extends State<SettingsFragment> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? _user;

  Future<void> _fetchUserData(String userId) async {
    DocumentSnapshot userSnapshot =
        await _firestore.collection('user').doc(userId).get();
    setState(() {
      _user = userSnapshot.data() as Map<String, dynamic>?;
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(themeColors: widget.themeColors)),
        (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _fetchUserData(currentUser.uid);
    }
    AppLangState.instance.loadAppLanguage();
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Korean'),
                onTap: () => _selectLanguage('ko'),
              ),
              ListTile(
                title: const Text('English'),
                onTap: () => _selectLanguage('en'),
              ),
              ListTile(
                title: const Text('Chinese'),
                onTap: () => _selectLanguage('zh'),
              ),
              ListTile(
                title: const Text('Japanese'),
                onTap: () => _selectLanguage('ja'),
              ),
            ],
          );
        });
  }

  void _selectLanguage(String language) {
    Navigator.pop(context);
    AppLangState.instance.setAppLanguage(language);
    setState(() {}); // Update the state to reflect the language change
  }

  @override
  Widget build(BuildContext context) {
    return _user == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // user info
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24.0, top: 30.0, bottom: 18.0),
                  child: Row(
                    children: [
                      // user profile
                      SizedBox(
                        width: 110.0,
                        height: 110.0,
                        child: CircleAvatar(
                          backgroundColor: _user!['profile_img_link'] == null
                              ? Colors.grey
                              : null,
                          backgroundImage: _user!['profile_img_link'] != null
                              ? NetworkImage(_user!['profile_img_link'])
                              : null,
                          radius: 20.0,
                        ),
                      ),
                      // Positioned(
                      //     right: 10,
                      //     bottom: 0,
                      //     child: SvgPicture.asset(
                      //       'assets/image/icon/Badge.svg',
                      //       width: 19.36,
                      //       height: 19.36,
                      //     )),
                      const SizedBox(
                        width: 25.0,
                      ),

                      // username
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${_user!['username'] ?? 'Unknown'}  🇰🇷", style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                          ),
                          const SizedBox(height: 12,),
                          Container(
                            width: 62,
                            height: 20,
                            decoration: BoxDecoration(
                              color: context.appColors.mainBlack,
                              borderRadius: BorderRadius.circular(100)
                            ),
                            child: Center(
                              child: Text('Edit profile', style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                                color: context.appColors.mainWhite
                              ),),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Text(
                      'Settings',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 40,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'My Saved',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        const Divider(
                          height: 20,
                          thickness: 1,
                          indent: 0,
                          endIndent: 25,
                          color: Colors.black26,
                        ),
                        GestureDetector(
                          onTap: () => _showLanguagePicker(context),
                          child: Container(
                            height: 40,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Language Preferences',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          height: 20,
                          thickness: 1,
                          indent: 0,
                          endIndent: 25,
                          color: Colors.black26,
                        ),
                        Container(
                          height: 40,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Display',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        const Divider(
                          height: 20,
                          thickness: 1,
                          indent: 0,
                          endIndent: 25,
                          color: Colors.black26,
                        ),
                        Container(
                          height: 40,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Privacy',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: context.appColors.baseGray,
                      // Text color
                      minimumSize: const Size(0, 40),
                      // Width and height
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(100), // Rounded corners
                      ), // Shadow elevation
                    ),
                    onPressed: _logout,
                    child: Text('Logout', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),))
              ],
    );
  }
}
