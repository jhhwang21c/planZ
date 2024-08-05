import 'package:flutter/material.dart';
import 'package:planZ/common/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planZ/app_state.dart';

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

  @override
  void initState() {
    super.initState();
    // Load user data and language preference
    _fetchUserData('FebuBZg9a1RZ2GbPHbbhegnza2M2');
    AppState.instance.loadAppLanguage();
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
    AppState.instance.setAppLanguage(language);
    setState(() {}); // Update the state to reflect the language change
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // user info
          Padding(
            padding: const EdgeInsets.only(
                left: 25.0, top: 25.0, bottom: 18.0),
            child: Row(
              children: [
                // user profile
                SizedBox(
                  width: 88.0,
                  height: 88.0,
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
                const SizedBox(
                  width: 25.0,
                ),

                // username
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("@${_user!['username'] ?? 'Unknown'}"),
                    SizedBox(
                      width: 108.0,
                      height: 25.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Following"),
                          Text(
                              "${_user!['following']?.length ?? "no following"}")
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 108.0,
                      height: 25.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Follower"),
                          Text(
                              "${_user!['follower']?.length ?? "no followers"}")
                        ],
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
                TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 20),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.schedule),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          'My Saved',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    indent: 0,
                    endIndent: 25,
                    color: Colors.black26,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.language),
                      GestureDetector(
                        onTap: () => _showLanguagePicker(context),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Language Preferences',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    indent: 0,
                    endIndent: 25,
                    color: Colors.black26,
                  ),
                  const Row(
                    children: [
                      Icon(
                        Icons.local_parking,
                        size: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Display',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    indent: 0,
                    endIndent: 25,
                    color: Colors.black26,
                  ),
                  const Row(
                    children: [
                      Icon(
                        Icons.contact_support_outlined,
                        size: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Privacy',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}