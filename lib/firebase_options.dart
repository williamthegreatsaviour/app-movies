import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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

  ///Note : Values available android/app/google-services.json
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'FIREBASE WEB API KEY',
    appId: 'FIREBASE ANDROID APP KEY',
    messagingSenderId: 'FIREBASE SENDER ID',
    projectId: 'FIREBASE PROJECT ID',
    storageBucket: 'FIREBASE STORAGE BUCKET',
  );

  ///Note : Values available ios/Runner/GoogleService-Info.plist
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'FIREBASE WEB API KEY',
    appId: 'FIREBASE iOS APP KEY',
    messagingSenderId: 'FIREBASE SENDER ID',
    projectId: 'FIREBASE PROJECT ID',
    storageBucket: 'FIREBASE STORAGE BUCKET',
    iosBundleId: 'FIREBASE iOS APP BUN',
  );

}
