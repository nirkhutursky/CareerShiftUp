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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDWw5JHkuX3izQqRQC6VIxMUPiD2dNDiC8',
    appId: '1:749558676091:web:bdecf3d5bd31cde55040de',
    messagingSenderId: '749558676091',
    projectId: 'careershiftup',
    authDomain: 'careershiftup.firebaseapp.com',
    storageBucket: 'careershiftup.appspot.com',
    measurementId: 'G-VYGPTB3LX0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA-RHiivfdsmT0ugjqZk3RRLiKbrEnkbXM',
    appId: '1:749558676091:android:ea0b8bc1ba685d055040de',
    messagingSenderId: '749558676091',
    projectId: 'careershiftup',
    storageBucket: 'careershiftup.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB2UrrQb0rWCeSzwHdJl062r3SZp1YwOes',
    appId: '1:749558676091:ios:f4ef319ddc284e1c5040de',
    messagingSenderId: '749558676091',
    projectId: 'careershiftup',
    storageBucket: 'careershiftup.appspot.com',
    iosClientId:
        '749558676091-a87vldovggf2l43j90e7p4ad83mt74v6.apps.googleusercontent.com',
    iosBundleId: 'com.example.jobSeeker',
  );
}
