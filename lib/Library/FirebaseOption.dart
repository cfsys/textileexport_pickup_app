// import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
//
// import 'AppConstant.dart';
//
//
// class DefaultFirebaseOptions {
//   static FirebaseOptions get currentPlatform {
//     switch (defaultTargetPlatform) {
//       case TargetPlatform.android:
//         return android;
//       case TargetPlatform.iOS:
//         return ios;
//       case TargetPlatform.windows:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions have not been configured for windows - '
//           'you can reconfigure this by running the FlutterFire CLI again.',
//         );
//       case TargetPlatform.linux:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions have not been configured for linux - '
//           'you can reconfigure this by running the FlutterFire CLI again.',
//         );
//       default:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions are not supported for this platform.',
//         );
//     }
//   }
//
//   static const FirebaseOptions android = FirebaseOptions(
//     apiKey: AppConstant.firebaseApiKey,
//     appId: AppConstant.firebaseAppId,
//     messagingSenderId: AppConstant.senderId,
//     projectId: AppConstant.projectId,
//     databaseURL: 'https://my-findi.firebaseio.com',
//     storageBucket: AppConstant.storageBucket,
//   );
//
//   static const FirebaseOptions ios = FirebaseOptions(
//     apiKey: AppConstant.firebaseApiKey,
//     appId: AppConstant.firebaseAppId,
//     messagingSenderId: AppConstant.senderId,
//     projectId: AppConstant.projectId,
//     databaseURL: 'https://my-findi.firebaseio.com',
//     storageBucket: AppConstant.firebaseAppId,
//     androidClientId: AppConstant.clientId,
//     iosClientId: AppConstant.clientId,
//     iosBundleId: AppConstant.iosPackage,
//   );
// }