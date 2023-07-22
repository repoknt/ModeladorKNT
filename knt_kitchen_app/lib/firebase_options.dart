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
    apiKey: 'AIzaSyBI1uDB1vHDuSjucLstbdc-0SaGknK6c-U',
    appId: '1:939120435806:web:2dbb5798df44d84b37cacf',
    messagingSenderId: '939120435806',
    projectId: 'kntkitchen-e39f4',
    authDomain: 'kntkitchen-e39f4.firebaseapp.com',
    storageBucket: 'kntkitchen-e39f4.appspot.com',
    measurementId: 'G-GFCK8TL819',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC48x3BSPihNONhZnAA6ZO_tM6j7mhTFG4',
    appId: '1:939120435806:android:897ad3314047c3fa37cacf',
    messagingSenderId: '939120435806',
    projectId: 'kntkitchen-e39f4',
    storageBucket: 'kntkitchen-e39f4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAQAMX8Ko24GNC2PIrgqQgel15RhsB-XIQ',
    appId: '1:939120435806:ios:d93c9ea14c0890ad37cacf',
    messagingSenderId: '939120435806',
    projectId: 'kntkitchen-e39f4',
    storageBucket: 'kntkitchen-e39f4.appspot.com',
    iosClientId: '939120435806-2ogre21kao5esap6594abauge2od5udk.apps.googleusercontent.com',
    iosBundleId: 'com.example.kntKitchenApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAQAMX8Ko24GNC2PIrgqQgel15RhsB-XIQ',
    appId: '1:939120435806:ios:ef5f57525c84c0e637cacf',
    messagingSenderId: '939120435806',
    projectId: 'kntkitchen-e39f4',
    storageBucket: 'kntkitchen-e39f4.appspot.com',
    iosClientId: '939120435806-3sq2ip2lhm20pnbomvim1q299s9e4hr3.apps.googleusercontent.com',
    iosBundleId: 'com.example.kntKitchenApp.RunnerTests',
  );
}