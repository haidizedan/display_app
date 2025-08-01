import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyDUj0JUrT0P-QynHevk9DRAnoRHLzCb2s0",
    authDomain: "display-app2.firebaseapp.com",
    projectId: "display-app2",
    storageBucket: "display-app2.appspot.com",
    messagingSenderId: "936889169936",
    appId: "1:936889169936:web:c81a487bc517d2d601b295",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyDUj0JUrT0P-QynHevk9DRAnoRHLzCb2s0",
    authDomain: "display-app2.firebaseapp.com",
    projectId: "display-app2",
    storageBucket: "display-app2.appspot.com",
    messagingSenderId: "936889169936",
    appId: "1:936889169936:web:c81a487bc517d2d601b295",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyDUj0JUrT0P-QynHevk9DRAnoRHLzCb2s0",
    authDomain: "display-app2.firebaseapp.com",
    projectId: "display-app2",
    storageBucket: "display-app2.appspot.com",
    messagingSenderId: "936889169936",
    appId: "1:936889169936:web:c81a487bc517d2d601b295",
    iosBundleId: 'com.example.displayApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: "AIzaSyDUj0JUrT0P-QynHevk9DRAnoRHLzCb2s0",
    authDomain: "display-app2.firebaseapp.com",
    projectId: "display-app2",
    storageBucket: "display-app2.appspot.com",
    messagingSenderId: "936889169936",
    appId: "1:936889169936:web:c81a487bc517d2d601b295",
    iosBundleId: 'com.example.displayApp',
  );
} 