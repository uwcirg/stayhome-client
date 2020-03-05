# map_app_flutter

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Troubleshooting
CouchbaseLite-Swift should be at least version 2.5.3, otherwise we might run into issues with swift version mismatches (at least with Xcode >=11).
Change this in fluttercouch.podspec (either .pubcache/host/... or in checkout directory if checking out fluttercouch from github separately).
Run `pod update CouchbaseLite-Swift`, then `pod install`

"The application's Info.plist does not contain CFBundleVersion."

The Xcode project should have CFBundleVersion ("Bundle version") under Runner target
(not project) -> Info -> Custo iOS Target Properties. It might be something like $(FLUTTER_BUILD_NAME)
 which will be null if this environment variable can't be resolved. For a quick fix, just change this
 to a hard coded number.

"Cocoa pods did not set the configuration because there is already a custom configuration... In order for
CocoaPods to work at all ..."

In Xcode click on the project -> Project (not target) -> Info tab -> Configurations -> change the
drop down for each of "Profile", "Release", and "Debug" to "None", then run `pod install`

"error: module compiled with Swift 5.0 cannot be imported by the Swift 5.1 compiler: "
 ... /mapapp/map-app-client/ios/Pods/CouchbaseLite-Swift/iOS/CouchbaseLiteSwift.framework/Modules/CouchbaseLiteSwift.swiftmodule/x86_64.swiftmodule
    import CouchbaseLiteSwift"

This is an issue with the Couchbase version dependency. Make sure you depend on a recent version of CouchbaseSwift (one that was compiled with swift 5.1 or newer).
One solution is to checkout fluttercouch and build from source, making sure to update the CouchbaseLite version in the podspec:

 pubspec.yaml:
 ```
 fluttercouch:
    path: ../fluttercouch/
 ```

 update version dependency:
 ```
 sed -i 's/~> 2.5.1/~> 2.6.3/g' ../fluttercouch/ios/fluttercouch.podspec
 ```