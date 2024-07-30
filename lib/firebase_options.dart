// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCdNTPRSC-tb-pWGgvb-vMEQ1y1HAoCOqE',
    appId: '1:214665888837:web:13872f4acf140870fd4f2c',
    messagingSenderId: '214665888837',
    projectId: 'planz-6ed47',
    authDomain: 'planz-6ed47.firebaseapp.com',
    storageBucket: 'planz-6ed47.appspot.com',
    measurementId: 'G-XG3W23HPR7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBt2GO_ZyvFySNUltcB5mFQk9cA9fCZJbM',
    appId: '1:214665888837:android:53d020bd5c151383fd4f2c',
    messagingSenderId: '214665888837',
    projectId: 'planz-6ed47',
    storageBucket: 'planz-6ed47.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBWYj2EyNy53RCJ9s7ylmgnsuuS9sxa00g',
    appId: '1:214665888837:ios:ecbdf6ff262011a0fd4f2c',
    messagingSenderId: '214665888837',
    projectId: 'planz-6ed47',
    storageBucket: 'planz-6ed47.appspot.com',
    iosClientId: '214665888837-e1ihtj5ddijs3btb0eu3gokldn3agqmj.apps.googleusercontent.com',
    iosBundleId: 'com.example.planZ',
  );

}