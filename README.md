# Screen Recording PPPC Guide

The Screen Recording PPPC Guide is a small script I wrote to guide the users to guide them to give screen recording to their favorite apps, using Swift Dialog (https://github.com/swiftDialog/swiftDialog). It launches the Security and Privacy system preference for macOS 12 and below, or system setting for macOS Ventura and higher, in the background in the right pane, and displays a small "how-to" for the user to help them check the proper authorizations for screen recording.

## How to use this?

- Add the contents of the ScreenRecordingPPPCGuide.sh in a Jamf Pro script.
- Deploy movies through a package, in _/usr/local/screen_recording_tutorial/movies_
- Create a Jamf Pro policy with the *At login* trigger, frequency set on "Once per computer per user".

Right after the user logs in, the policy is run and the Dialog app will display a few dialogs with videos. Adapt the script with the path and with your own dialog. If you use French, you can use the videos I added, otherwise, feel free to replace them with your own.

