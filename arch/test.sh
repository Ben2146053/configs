#!/bin/bash
echo "Please enter the path to your custom configuration directory located in ~home/:"
read -r USER_INPUT
CONFIG_PATH=${USER_INPUT:-~/Documents/configs/}

sudo pacman -S --noconfirm firefox
profile_folder=$(find ~/.mozilla/firefox -maxdepth 1 -type d -name "*default-release")
if [ -z "$profile_folder" ]; then
    echo "Firefox profile folder with 'default-release' not found."
    exit 1
fi
# Path to prefs.js file in the profile folder
prefs_js_path="$profile_folder/prefs.js"

# Enable toolkit.legacyUserProfileCustomizations.stylesheets
if ! grep -q 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' "$prefs_js_path"; then
    echo 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' >> "$prefs_js_path"
    echo "Enabled toolkit.legacyUserProfileCustomizations.stylesheets in prefs.js"
else
    echo "toolkit.legacyUserProfileCustomizations.stylesheets is already enabled"
fi

css_source=$CONFIG_PATH/firefox/chrome/userChrome.css
mkdir -p "$profile_folder/chrome"
cp "$css_source" "$profile_folder/chrome/userChrome.css"
