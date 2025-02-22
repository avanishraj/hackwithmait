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
        return windows;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCM9CnJ07pHzZr_gLJ8f27DI0xWLGkNrfM',
    appId: '1:426028777564:android:934ed29d206699729f2699',
    messagingSenderId: '426028777564',
    projectId: 'hackwithinfy-3e8b7',
    storageBucket: 'hackwithinfy-3e8b7.appspot.com',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAfzxwRa_ILjs5URydxoyviKB1NMU1QzZE',
    appId: '1:426028777564:web:33b682ebc9fd18149f2699',
    messagingSenderId: '426028777564',
    projectId: 'hackwithinfy-3e8b7',
    authDomain: 'hackwithinfy-3e8b7.firebaseapp.com',
    storageBucket: 'hackwithinfy-3e8b7.appspot.com',
    measurementId: 'G-MDCWK5LV67',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCj8BrVNLYt0KpOL8Jj0cBVNO-2CxXe-vk',
    appId: '1:426028777564:ios:b7446a8b436005bc9f2699',
    messagingSenderId: '426028777564',
    projectId: 'hackwithinfy-3e8b7',
    storageBucket: 'hackwithinfy-3e8b7.appspot.com',
    iosBundleId: 'com.example.hackwithinfy',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAfzxwRa_ILjs5URydxoyviKB1NMU1QzZE',
    appId: '1:426028777564:web:3d02daea6253fbcf9f2699',
    messagingSenderId: '426028777564',
    projectId: 'hackwithinfy-3e8b7',
    authDomain: 'hackwithinfy-3e8b7.firebaseapp.com',
    storageBucket: 'hackwithinfy-3e8b7.appspot.com',
    measurementId: 'G-69EXWSCZ57',
  );

}