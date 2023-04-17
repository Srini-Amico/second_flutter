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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCCJ2SwdVThPHlo-a3EoCAKwD01cBTZomY',
    appId: '1:803763215837:android:1c52b26cde8ab0afdb6a34',
    messagingSenderId: '803763215837',
    projectId: 'anystuff-a2fdd',
    storageBucket: 'anystuff-a2fdd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCIcXxXKzVDKFujRlJWd_lqLfe4OBTMnos',
    appId: '1:726203508641:ios:5433870c19ea32011b8de0',
    messagingSenderId: '726203508641',
    projectId: 'gpstore-user-app',
    storageBucket: 'gpstore-user-app.appspot.com',
    androidClientId: '726203508641-a4km5pnn5si82pc1tg012hfdvnhha0v5.apps.googleusercontent.com',
    iosClientId: '726203508641-k66lj87p963qnvpv4m7lphm4hhnd54l4.apps.googleusercontent.com',
    iosBundleId: 'rent.anystuff',
  );
}
