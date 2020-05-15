# StayHome
The COVID-19 pandemic is straining existing public health processes and workflows. Many community members may be concerned about developing COVID-19. To support community members, we have developed StayHome.

StayHome (https://stayhome.app) is a mobile-friendly web app that supports people who want to track COVID-19 symptoms; link to CDC’s Self-Checker decision support; record at-risk conditions, exposures/contacts/travel or COVID-19 testing/results; and find sources for information. StayHome lets users choose to share identified or anonymous information with public health agencies. The project is described at: https://project.stayhome.app, and the button on that page links to the app, which does not require installation. You do not need an account to access information about COVID-19, and you can create an account to start self-tracking. The app is available for public use. Feel free to share the links.

Developed by the Clinical Informatics Research Group (CIRG) at University of Washington, 2019-2020. Read more about us at [https://www.cirg.washington.edu/](https://www.cirg.washington.edu/)

The project is hosted at [https://stayhome.app/](https://stayhome.app/)

Project information can be found at [https://project.stayhome.app/](https://project.stayhome.app/)

The changelog is at [https://uwcirg.github.io/stayhomelanding/#change-log](https://uwcirg.github.io/stayhomelanding/#change-log)

The informational resources are located at [https://resources.stayhome.app/](https://resources.stayhome.app/)


## CodeSystem
StayHome makes use of some internal codes as follows.
- The login page will display the most recently `sent` Communication with a `status` of `in-progress` and a `category` of `https://stayhome.app/CodeSystem/communication-category|system-announcement`

# Development
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
