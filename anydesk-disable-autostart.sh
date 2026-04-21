#!/bin/zsh

# Post-install one-liner for Jamf to disable Anydesk auto-start on managed Macs
# Jamf will run the script as root automatically

sudo plutil -replace RunAtLoad -bool false /Library/LaunchAgents/com.philandro.anydesk.Frontend.plist; cat /Library/LaunchAgents/com.philandro.anydesk.Frontend.plist > /var/log/anydesk_shutup.log; sudo jamf policy -id 1
