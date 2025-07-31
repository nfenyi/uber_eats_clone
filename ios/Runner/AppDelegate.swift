import Flutter
import UIKit
#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices provideAPIKey:("AIzaSyD0RD3-1CW7alhs03RMBLPhv8TdiwDKeyQ") //TODO: Replace this with your API key but hide it this time
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)

//     NSString* mapsApiKey = [[NSProcessInfo processInfo] environment[@"MAPS_API_KEY"];

// [GMSServices provideAPIKey:mapsApiKey];
  }
}


