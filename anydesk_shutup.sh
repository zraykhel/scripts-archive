#! /bin/zsh

### Post-install one-liner for Jamf to disable Anydesk auto-start on managed Macs

sudo plutil -replace RunAtLoad -bool false /Library/LaunchAgents/com.philandro.anydesk.Frontend.plist
cat /Library/LaunchAgents/com.philandro.anydesk.Frontend.plist > /var/log/anydesk_shutup.log
sudo jamf policy -id 1