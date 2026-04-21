#!/bin/zsh

# Forgets the pre-configured network, disables MAC address randomisation
# which is enabled by default in macOS 15, and reboots.
# Does not need sudo since MDM executes script as root

# Forget the network pre-configured with the MDM profile
networksetup -removepreferredwirelessnetwork en0 "SSID"

# Disable MAC address randomisation globally
defaults write /Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist PrivateMACAddressModeSystemSetting -int 1

# Reboot to apply changes
shutdown -r now
