import 'package:firebase_core/firebase_core.dart'
  show FirebaseOptions;
import 'package:flutter/foundation.dart'
  show defaultTargetPlatform,
       kIsWeb,
       TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.android:
        return android;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBpSlYmRWF42GaK0_0wgCask7yykEvUbWQ',
    appId: '1:1097380049844:web:17d1e08d4588be8da6b8e1',
    messagingSenderId: '1097380049844',
    projectId: 'portafoglio-aurelius',
    authDomain: 'portafoglio-aurelius.firebaseapp.com',
    storageBucket:
      'portafoglio-aurelius.firebasestorage.app',
    measurementId: 'G-TL113SGKDG',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBpSlYmRWF42GaK0_0wgCask7yykEvUbWQ',
    appId: '1:1097380049844:web:17d1e08d4588be8da6b8e1',
    messagingSenderId: '1097380049844',
    projectId: 'portafoglio-aurelius',
    authDomain: 'portafoglio-aurelius.firebaseapp.com',
    storageBucket:
      'portafoglio-aurelius.firebasestorage.app',
    iosBundleId: 'com.aurelius.portfolio',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBpSlYmRWF42GaK0_0wgCask7yykEvUbWQ',
    appId: '1:1097380049844:web:17d1e08d4588be8da6b8e1',
    messagingSenderId: '1097380049844',
    projectId: 'portafoglio-aurelius',
    authDomain: 'portafoglio-aurelius.firebaseapp.com',
    storageBucket:
      'portafoglio-aurelius.firebasestorage.app',
  );
}
