// import Flutter
// import UIKit
// import Firebase
//
// @main
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     GeneratedPluginRegistrant.register(with: self)
//
//       FirebaseApp.configure()
//
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }

import Flutter
import UIKit
import Firebase
import OneSignalFramework



@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

     OneSignal.initialize("63ee6b62-850f-4126-b21a-a264c8ae7cc4")
    // Initialize Firebase
     FirebaseApp.configure()
    // Register plugins
    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
