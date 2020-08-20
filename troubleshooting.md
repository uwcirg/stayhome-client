# Development / Troubleshooting
## Flutter Troubleshooting
"The application's Info.plist does not contain CFBundleVersion."

The Xcode project should have CFBundleVersion ("Bundle version") under Runner target
(not project) -> Info -> Custom iOS Target Properties. It might be something like $(FLUTTER_BUILD_NAME)
 which will be null if this environment variable can't be resolved. For a quick fix, just change this
 to a hard coded number.

"Cocoa pods did not set the configuration because there is already a custom configuration... In order for
CocoaPods to work at all ..."

In Xcode click on the project -> Project (not target) -> Info tab -> Configurations -> change the
drop down for each of "Profile", "Release", and "Debug" to "None", then run `pod install`

On iOS, if you start getting "no user" errors on hot reload or hot restart, try restarting the simulator.
