
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA4XZNeaoEUgjCl7fRSakC91PaTD2OAmN8',
    appId: '1:195128959733:web:8757af9419aaa5747b5bbc',
    messagingSenderId: '195128959733',
    projectId: 'todoapp-c21c9',
    authDomain: 'todoapp-c21c9.firebaseapp.com',
    storageBucket: 'todoapp-c21c9.firebasestorage.app',
    measurementId: 'G-GF49M7D972',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA2b4o2URrx5ulv_hKcrZK9l8n3qJaPPeA',
    appId: '1:195128959733:android:c7ec03cbd71c24267b5bbc',
    messagingSenderId: '195128959733',
    projectId: 'todoapp-c21c9',
    storageBucket: 'todoapp-c21c9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD81XLvVnVb9mtvuXTJEmUhCuJmu5jKsyY',
    appId: '1:195128959733:ios:a4827ab30f536fed7b5bbc',
    messagingSenderId: '195128959733',
    projectId: 'todoapp-c21c9',
    storageBucket: 'todoapp-c21c9.firebasestorage.app',
    iosBundleId: 'com.example.todoapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD81XLvVnVb9mtvuXTJEmUhCuJmu5jKsyY',
    appId: '1:195128959733:ios:a4827ab30f536fed7b5bbc',
    messagingSenderId: '195128959733',
    projectId: 'todoapp-c21c9',
    storageBucket: 'todoapp-c21c9.firebasestorage.app',
    iosBundleId: 'com.example.todoapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA4XZNeaoEUgjCl7fRSakC91PaTD2OAmN8',
    appId: '1:195128959733:web:c35b5defb147a1177b5bbc',
    messagingSenderId: '195128959733',
    projectId: 'todoapp-c21c9',
    authDomain: 'todoapp-c21c9.firebaseapp.com',
    storageBucket: 'todoapp-c21c9.firebasestorage.app',
    measurementId: 'G-0FNHNVE177',
  );
}
