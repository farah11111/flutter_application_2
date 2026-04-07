import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return android;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBy4PDNq43-zgw5DNhnAN15Z4gIynm6VrA',
    authDomain: 'aegismind-d67fe.firebaseapp.com',
    projectId: 'aegismind-d67fe',
    storageBucket: 'aegismind-d67fe.firebasestorage.app',
    messagingSenderId: '560116831118',
    appId: '1:560116831118:web:c7daf234a18615c7ac8adf',
    measurementId: 'G-9M0S478Y2B',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBy4PDNq43-zgw5DNhnAN15Z4gIynm6VrA',
    authDomain: 'aegismind-d67fe.firebaseapp.com',
    projectId: 'aegismind-d67fe',
    storageBucket: 'aegismind-d67fe.firebasestorage.app',
    messagingSenderId: '560116831118',
    appId: '1:560116831118:android:fa5b95dc20e16775ac8adf',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBy4PDNq43-zgw5DNhnAN15Z4gIynm6VrA',
    authDomain: 'aegismind-d67fe.firebaseapp.com',
    projectId: 'aegismind-d67fe',
    storageBucket: 'aegismind-d67fe.firebasestorage.app',
    messagingSenderId: '560116831118',
    appId: '1:560116831118:web:c7daf234a18615c7ac8adf',
  );
}
