#!/bin/zsh

### Allows to change account picture when 'Users & Groups' settings tab is locked by MDM
### Removes the previous picture, copies the new one to the special directory, converts it into .heic, sets it and sends a custom message back to the MDM server
### Works only on the account the user is currently logged into

# Get logged-in user
LOGIN=$(users)

# Delete currently used photo
dscl . delete /Users/$LOGIN JPEGPhoto
sleep 1

# Delete file path
dscl . delete /Users/$LOGIN Picture
sleep 1

# Copy new avatar to User Pictures where avatars are stored
cp /Users/$LOGIN/Desktop/source.jpg /Library/User\ Pictures/source.heic
sleep 1

# Set new avatar and apply permissions to make it visible to user (otherwise it shows empty)
dscl . create /Users/$LOGIN Picture /Library/User\ Pictures/source.heic && chmod 644 /Library/User\ Pictures/source.heic
STATUS=$?

if [ $? -eq 0 ]; then
    echo 'The picture has been changed successfully'
else
    'Failed to change the picture'
fi
