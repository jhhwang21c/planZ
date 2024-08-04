import 'package:flutter/material.dart';
import 'package:planZ/common/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    //below should be signed-in user
    _fetchUserData('FebuBZg9a1RZ2GbPHbbhegnza2M2');
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
            padding: const EdgeInsets.only(left: 24.0, top: 12.0, bottom: 18.0),
            child: Row(
              children: [
                // user profile
                Container(
                  width: 88.0,
                  height: 88.0,
                  child: CircleAvatar(
                    backgroundColor:
                    _user!['profile_img_link'] == null ? Colors.grey : null,
                    backgroundImage: _user!['profile_img_link'] != null
                        ? NetworkImage(_user!['profile_img_link'])
                        : null,
                    radius: 20.0,
                  ),
                ),
                const SizedBox(
                  width: 24.0,
                ),

                // username
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("@${_user!['username'] ?? 'Unknown'}"),
                    SizedBox(
                      width: 108.0,
                      height: 24.0,
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
                      height: 24.0,
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
              padding: EdgeInsets.only(left: 24.0),
              child: Text(
                'Settings',
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: Column(children: [
                Text('1', style: TextStyle(fontSize: 25),),
                Text('2', style: TextStyle(fontSize: 25),),
                Text('3', style: TextStyle(fontSize: 25),),


              ],),
            ),
          ),
        ],
      ),
    );
  }
}