// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return macos;
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
    apiKey: 'AIzaSyCISFgk0kAz1xX7GlR0gFB0dYKyhB7Vo-4',
    appId: '1:511357893450:web:cb0515be222fda7728dfb3',
    messagingSenderId: '511357893450',
    projectId: 'alzheimerapp-9c65f',
    authDomain: 'alzheimerapp-9c65f.firebaseapp.com',
    storageBucket: 'alzheimerapp-9c65f.appspot.com',
    measurementId: 'G-NBKYWEMYR1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD5jvQMbWw61YToWAVAdsT6LHsCQlrKah8',
    appId: '1:511357893450:android:00d0edafa698d01028dfb3',
    messagingSenderId: '511357893450',
    projectId: 'alzheimerapp-9c65f',
    storageBucket: 'alzheimerapp-9c65f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDDcyPWx7tufBSgC96o43QSFnzCAQLwoF4',
    appId: '1:511357893450:ios:69959cc961e862ec28dfb3',
    messagingSenderId: '511357893450',
    projectId: 'alzheimerapp-9c65f',
    storageBucket: 'alzheimerapp-9c65f.appspot.com',
    iosBundleId: 'com.example.alzheimersapporig',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDDcyPWx7tufBSgC96o43QSFnzCAQLwoF4',
    appId: '1:511357893450:ios:b2f9f7caf95b5b1c28dfb3',
    messagingSenderId: '511357893450',
    projectId: 'alzheimerapp-9c65f',
    storageBucket: 'alzheimerapp-9c65f.appspot.com',
    iosBundleId: 'com.example.alzheimersapporig.RunnerTests',
  );
}