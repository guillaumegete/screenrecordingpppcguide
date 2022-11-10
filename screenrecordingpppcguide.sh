#!/bin/bash

# Guillaume Gète
# 03/10/2022

# Displays a tutorial explaining how to configure the Security and Privacy System preference to add Screen recording authorizations for most used apps (i.e. videoconferencing apps).
# Ideally to launch at the user's 2nd login.

# v 1.0

# Get current user

consoleuser=$(stat -f%Su /dev/console)

# Ouverture du panneau de préférence

sudo -u "$consoleuser" open "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture"

# IBM Notifier binary path. Adapt to your own if you customized the IBM Notifier app. 
# Note that you must specify the full path to the binary inside the .app file!
# i.e. /Applications/Utilities/IBM Notifications.app/Contents/MacOS/IBM Notifications
# Do not escape spaces in the path.

NA_PATH="/Applications/Utilities/IBM Notifications.app/Contents/MacOS/IBM Notifications"

## First dialog
WINDOWTYPE="popup"
BAR_TITLE="IMPORTANT: Allow your applications to record the screen!"
TITLE1="Check the box in front of each application in the window that has just opened (videoconference, remote support...). \n"
BUTTON_1="Next"

PU_PIC="/usr/local/images/screenrecording/screenrecording.png"

RESPONSE=$("${NA_PATH}" \
    -type "${WINDOWTYPE}" \
    -bar_title "${BAR_TITLE}" \
    -title "${TITLE1}" \
    -main_button_label "${BUTTON_1}" \
    -accessory_view_type "image" \
    -accessory_view_payload "${PU_PIC}" \
    -always_on_top \
    -silent)
    
## Second dialog

TITLE="Drag with the trackpad with two fingers down into the window to display more applications to allow. \n"
PU_PIC="/usr/local/images/screenrecording/screenrecording.gif"
BUTTON_1="Continuer"

RESPONSE=$("${NA_PATH}" \
    -type "${WINDOWTYPE}" \
    -bar_title "${BAR_TITLE}" \
    -title "${TITLE}" \
    -main_button_label "${BUTTON_1}" \
    -accessory_view_type "image" \
    -accessory_view_payload "$PU_PIC" \
    -always_on_top \
    -silent)

## Third dialog

TITLE="If you need to allow new applications, click on the menu  > System Preferences and then open Security and Privacy > Privacy.\n"
PU_PIC="/usr/local/images/screenrecording/prefsysteme.png"
BUTTON_1="Done !"

RESPONSE=$("${NA_PATH}" \
    -type "${WINDOWTYPE}" \
    -bar_title "${BAR_TITLE}" \
    -title "${TITLE}" \
    -main_button_label "${BUTTON_1}" \
    -accessory_view_type "image" \
    -accessory_view_payload "${PU_PIC}" \
    -always_on_top \
    -silent)


# Quit the System Preferences app

   osascript -e 'tell app "System Preferences" to quit'
    
