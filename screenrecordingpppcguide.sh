#!/bin/bash

# Guillaume Gète
# 03/10/2022

# Displays a tutorial explaining how to configure the Security and Privacy System preference to add Screen recording authorizations for most used apps (i.e. videoconferencing apps).
# Ideally to launch at the user's 2nd login.

# v 1.0


# v 1.0 : Initial release
# v 1.1 : Adapted for macOS Ventura (non public)
# v 1.2 : Rewritten to use SwitftDialog (and installs it if needed). Now uses videos instead of fixed images.

# Variables

# Username

consoleUser=$(stat -f%Su /dev/console)

moviesDirectory="/usr/local/screen_recording_tutorial/movies"

# If the folder that contain the videos is not available, we don't run the script.


if [ ! -d "$moviesDirectory" ]; then
  echo "Le dossier $moviesDirectory est introuvable."
  exit 1
fi

#=======================================================================#
#--------------------#     Language detection      #--------------------#
#=======================================================================#

langs=$(sudo -u "$consoleUser" defaults read NSGlobalDomain AppleLanguages | sed -n '2p' | cut -c 6-10)

currentlang=$(echo "${langs[1]/,/}") # langs[0] is the open bracket

# echo $currentlang
echo "$langs"

if [ "$langs" = "fr-FR" ]; then
  # Chemin du dossier contenant les fichiers vidéo
  contentFolder="/usr/local/screen_recording_tutorial/movies/fr/"
else
  contentFolder="/usr/local/screen_recording_tutorial/movies/en"
fi

#=======================================================================#
#--------------------#  SwiftDialog Installation   #--------------------#
#=======================================================================#

# Requiert l'app SwiftDialog. Elle sera téléchargée et installée si absente.

dialogPath="/usr/local/bin/dialog"
dialogURL=$(curl --silent --fail "https://api.github.com/repos/bartreardon/swiftDialog/releases/latest" | awk -F '"' "/browser_download_url/ && /pkg\"/ { print \$4; exit }")

if [ ! -e "$dialogPath" ]; then
  echo "Dialog tool must be installed first."
  curl -L "$dialogURL" -o "/tmp/dialog.pkg"
  installer -pkg /tmp/dialog.pkg -target /
  
  if [ ! -e "$dialogPath" ]; then
    echo "An error occured, dialog tool could not be installed."
    exit 1
  else
    echo "Dialog tool available…..."
  fi
else 
  echo "Dialog tool available…"
fi


# Do we open System Preferences or Settings (if macOS > 12)?

sudo -u "$consoleUser" open "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture"

sleep 2

macosBuild=$(sw_vers -buildVersion | cut -b 1-2)

# macOS builds :
# Mojave = 18
# Catalina = 19
# Big Sur = 20
# Monterey = 21
# Ventura = 22

# Function to display the alert using Dialog

displayAlert () {
  
  # If contents is not an image, we assume safely that's a video..
  
  RESPONSE=$("${dialogPath}" \
    --title "$dialogTitle" \
    --videocaption "$dialogMessage" \
    --button1text "$dialogButton" \
    --titlefont "colour=#005FAD,size=22" \
    --position topright \
    --icon none \
    --width 48% \
    --video "$contentFolder/$movieName" --autoplay)
}

echo "Build de macOS : version $macosBuild"

## First dialog. Different according to macOS version.

if [ "$langs" = "fr-FR" ]; then
  dialogTitle="IMPORTANT : Autorisez vos applications à enregistrer l'écran !"
else
  dialogTitle="IMPORTANT: Allow your applications to record the screen!"
fi


if [ "$langs" = "fr-FR" ] && [ "$macosBuild" -gt "21" ]; then
  movieName="ScreenRecording_Ventura_Checkbox_FR.mov"
  dialogMessage="Cochez la case en face de chaque application dans la fenêtre qui vient de s'ouvrir (visioconférence, prise en main à distance…)."
  dialogButton="Suivant"
  
elif [ "$langs" = "fr-FR" ] && [ "$macosBuild" -ge "21" ]; then
  dialogMessage="Cochez la case en face de chaque application dans la fenêtre qui vient de s'ouvrir (visioconférence, prise en main à distance…)."
  dialogButton="Suivant"
  movieName="ScreenRecording_Monterey_Checkbox_FR.mov"
  
elif [ "$langs" != "fr-FR" ] && [ "$macosBuild" -gt "21" ]; then
  dialogMessage="Check the box in front of each application in the window that has just opened (videoconferencing, remote handling...)."
  dialogButton="Next"
  movieName="ScreenRecording_Ventura_Checkbox_EN.mov"
  
elif [ "$langs" != "fr-FR" ] && [ "$macosBuild" -ge "21" ]; then
  dialogMessage="Check the box in front of each application in the window that has just opened (videoconferencing, remote handling...)."
  dialogButton="Next"
  movieName="ScreenRecording_Monterey_Checkbox_EN.mov"
fi

displayAlert

## Second dialog

if [ "$langs" = "fr-FR" ] && [ "$macosBuild" -gt "21" ]; then
  movieName="ScreenRecording_Ventura_Quit_Reopen_FR.mov"
  dialogMessage="Si une application affiche un message, cliquez sur Quitter et rouvrir."
  dialogButton="Suivant"
  
elif [ "$langs" = "fr-FR" ] && [ "$macosBuild" -ge "21" ]; then
  dialogMessage="Glissez avec le trackpad avec deux doigts vers le bas dans la fenêtre pour afficher plus d'applications."
  movieName="ScreenRecording_Monterey_Check_Trackpad_FR.mov"
  dialogButton="Continuer"
  
elif [ "$langs" != "fr-FR" ] && [ "$macosBuild" -gt "21" ]; then
  dialogMessage="If an application displays a message, click on Quit and reopen."
  dialogButton="Next"
  movieName="ScreenRecording_Ventura_Quit_Reopen_EN.mov"
  
elif [ "$langs" != "fr-FR" ] && [ "$macosBuild" -ge "21" ]; then
  dialogMessage="Swipe up or down on the trackpad with two fingers in the window to display more applications to check."
  dialogButton="Next"
  movieName="ScreenRecording_Monterey_Check_Trackpad_EN.mov"
fi

displayAlert


## Third dialog

if [ "$langs" = "fr-FR" ] && [ "$macosBuild" -gt "21" ]; then
  dialogMessage="Pour autoriser de nouvelles applications, cliquez sur le menu  > Réglages Système puis cherchez Enregistrer."
  movieName="ScreenRecording_Ventura_Search_FR.mov"
  dialogButton="Quitter"
  
elif [ "$langs" = "fr-FR" ] && [ "$macosBuild" -ge "21" ]; then
  dialogMessage="Pour autoriser de nouvelles applications, cliquez sur le menu  > Préférences Système puis cherchez Enregistrer."
  movieName="ScreenRecording_Monterey_Search_FR.mov"
  dialogButton="Quitter"
  
elif [ "$langs" != "fr-FR" ] && [ "$macosBuild" -gt "21" ]; then
  dialogMessage="To authorize new applications, click  menu > System Settings and then search for Screen Record."
  movieName="ScreenRecording_Ventura_Search_EN.mov"
  dialogButton="Quit"
  
elif [ "$langs" != "fr-FR" ] && [ "$macosBuild" -ge "21" ]; then
  dialogMessage="To allow new apps, click menu  menu > Security and Privacy, then swipe down and select Screen Recording."
  movieName="ScreenRecording_Monterey_Search_EN.mov"
  dialogButton="Quit"
fi

displayAlert

# Let's try to quit System Preferences / Settings. Works for any version of macOS, hopefully.

osascript -e 'try' -e 'tell app "System Preferences" to quit' -e 'end try'