import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServicews {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //for signup
  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    User? user;
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = credential.user;
    } catch (e) {
      print(e.toString());
    }
    return user;
  }

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    User? user;
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = credential.user;
    } catch (e) {
      print(e.toString());
    }
    return user;
  }

  Future<void> createUserProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection("user").doc(uid).set(data);
    } catch (e) {
      print(e.toString());
    }
  }


  Future<void> updateUserProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection("user").doc(uid).update(data);
    } catch (e) {
      print(e.toString());
    }
  }

}
