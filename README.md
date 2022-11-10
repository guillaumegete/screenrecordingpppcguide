# Screen Recording PPPC Guide

The Screen Recording PPPC Guide is a small script I wrote to guide the users to guide them to give screen recording to their favorite apps, using IBM Notifier (https://github.com/IBM/mac-ibm-notifications). It launches the Security and Privacy system preference in the background in the right pane, and displays a small how-to for the user to help them check the proper authorizations for screen recording.

**IMPORTANT: it's not been adapted yet for macOS Ventura (the screen captures are not adapted for the new System Settings stuff), *however* it should work fine on it (I tested the URL to open the right prefpane and it works fine, you'll have to adapt the screen captures of course).**

## How to use this?

- Add the contents of the ScreenRecordingPPPCGuide.sh in a Jamf Pro script.
- Create a smart group with criteria "Has IBM Notifier installed".
- Create a Jamf Pro policy with the *At login* trigger, frequency set on "Once per computer per user", and scoped only on Macs that have IBM Notifier installed.
- To keep control of deployment, I use DEPNotify with the [DEPNotify Starter](https://github.com/jamf/DEPNotify-Starter) script, installing IBM Notifier in the process.
- At the end of deployment, perform `jamf recon` and request a reboot.
- Computer reboots.

After reboot, the policy runs the Screen Recording PPPC Guide script, that launches IBM Notifier and displays a few dialogs with pictures. Adapt the script with the path and with your own dialog. If you use French, you can use the screen captures I added, otherwise, feel free to replace them with your own.


