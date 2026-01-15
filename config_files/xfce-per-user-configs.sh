#!/bin/bash

set -e

CHANNEL_SHORTCUTS="xfce4-keyboard-shortcuts"
SESSION_CHANNEL="xfce4-session"
PANEL_XML="$HOME/.config/xfce4/xfce-perchannel-xml/xfce4-panel.xml"

echo "Applying XFCE shortcuts, tiling, power settings, and user menu options..."

# ----------------------------
# KEYBOARD SHORTCUTS
# ----------------------------

xfconf-query -c $CHANNEL_SHORTCUTS \
  -p "/commands/custom/<Control><Alt><Shift>w" -n -t string -s "xfce4-popup-whiskermenu"

xfconf-query -c $CHANNEL_SHORTCUTS \
  -p "/commands/custom/<Control><Alt>t" -n -t string -s "xfce4-terminal"

xfconf-query -c $CHANNEL_SHORTCUTS \
  -p "/commands/custom/<Control><Alt>l" -n -t string -s "xflock4"

xfconf-query -c $CHANNEL_SHORTCUTS \
	     -p "/commands/custom/<Print>" -n -t string -s "xfce4-screenshooter"

# xfconf-query -c $CHANNEL_SHORTCUTS \
#   -p "/commands/custom/<Alt>Tab" -n -t string -s "cycle_windows_key"

# ----------------------------
# WINDOW TILING (XFWM4)
# ----------------------------

xfconf-query -c xfwm4 -p /general/tile_left -n -t string -s "<Super>Left"
xfconf-query -c xfwm4 -p /general/tile_right -n -t string -s "<Super>Right"

# ----------------------------
# POWER MANAGEMENT SETTINGS
# ----------------------------

xfconf-query -c xfce4-power-manager \
  -p "/xfce4-power-manager/inactivity-on-ac" -n -t int -s 0

# ----------------------------
# USER MENU OPTIONS (xfce4-session)
# ----------------------------

# Hide standard buttons via xfconf
xfconf-query -c $SESSION_CHANNEL -p "/shutdown/ShowShutdown" -n -t bool -s false
xfconf-query -c $SESSION_CHANNEL -p "/shutdown/ShowSuspend" -n -t bool -s false
xfconf-query -c $SESSION_CHANNEL -p "/shutdown/ShowSwitchUser" -n -t bool -s false

# Show only "Log Out" without prompt
xfconf-query -c $SESSION_CHANNEL -p "/shutdown/ShowLogout" -n -t bool -s true
xfconf-query -c $SESSION_CHANNEL -p "/shutdown/ShowLogoutPrompt" -n -t bool -s false
xfconf-query -c xfce4-session -p /general/PromptOnLogout -n -t bool -s false

# Disable XFCE monitor layout auto-apply (prevents "xfdesktop assign layout" popup)
#rm -rf ~/.config/xfce4/desktop/
# Is this destroying the desktop shortcuts?
#rm -f ~/.config/xfce4/desktop/icons*yaml
xfconf-query -c displays -p /Notify -n -t int -s 0
xfconf-query -c displays -p /AutoApply -n -t bool -s true
xfconf-query -c xfce4-desktop -p /desktop-icons/style -n -t int -s 2
#xfconf-query -c xfce4-desktop -p /desktop-icons/last-monitor-layout -n -t int -s 0

# ----------------------------#
# Remove some options from panel
# ----------------------------#

# Find the plugin number that stores the actions
plugin=$(xfconf-query -c xfce4-panel -p /plugins -lv | grep 'actions' | awk -F'/' '{print $3}' | awk '{print $1}')
echo $plugin
xfconf-query -c xfce4-panel -p /plugins/$plugin -n -t string -s "actions"
xfconf-query -c xfce4-panel -p /plugins/$plugin/items -r -R || true
xfconf-query -c xfce4-panel -p /plugins/$plugin/items -n \
	     -t string -s "+lock-screen" \
	     -t string -s "-switch-user" \
	     -t string -s "+separator" \
	     -t string -s "-suspend" \
	     -t string -s "-hibernate" \
	     -t string -s "-hybrid-sleep" \
	     -t string -s "-separator" \
	     -t string -s "-shutdown" \
	     -t string -s "+restart" \
	     -t string -s "+separator" \
	     -t string -s "+logout" \
	     -t string -s "-logout-dialog"
# ----------------------------



# ----------------------------#
# Remove annoying security warning from passwd.desktop shortcut
# ----------------------------#
FILE="$HOME/Desktop/passwd.desktop"
USER_NAME=$(basename "$HOME")
dbus-run-session gio set -t string "$FILE" \
     metadata::xfce-exe-checksum "$(sha256sum $(readlink -f "$FILE") | awk '{print $1}')"
# ----------------------------#


#---------------------------------------------------#
# Change Whiskermenu to show Icon and Title
#---------------------------------------------------#
CHANNEL="xfce4-panel"
PLUGIN_VALUE="whiskermenu"

# Find the Whisker Menu plugin that has a button-icon property
PLUGIN_ID=$(
  xfconf-query -c "$CHANNEL" -l 2>/dev/null |
  awk '
    /\/plugins\/plugin-[0-9]+\/button-icon$/ {
        sub(/\/button-icon$/, "", $0)
        print
    }
  ' |
  while read -r BASE; do
    TYPE=$(xfconf-query -c "$CHANNEL" -p "$BASE" 2>/dev/null)
    [ "$TYPE" = "whiskermenu" ] && echo "$BASE"
  done |
  sed 's|/plugins/||' |
  head -n 1
)

xfconf-query -c "$CHANNEL" -p /plugins/$PLUGIN_ID/show-button-title -s true
#---------------------------------------------------#

echo "All XFCE settings applied."
echo "You may need to log out and log back in, or restart the panel (xfce4-panel -r) for all changes to fully take effect."
