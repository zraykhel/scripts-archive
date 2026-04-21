#!/bin/bash
​
# Version 2 of the script
# Allows to set a profile picture when 'Users & Groups' tab is locked by MDM
# Mounts a network share with photos' directory, retrieves the user's photo, formats it and sets as profile picture
# Dynamically adjsuts if newer photos were uploaded to the share (partially drafted with AI)
# SHARENAME and PHOTOSDIR are placeholders

# ============================================================================
# SMB Share Connection and File Download Script
# ============================================================================
​
# 1. Get the username and store in variable
USERNAME=$(users) # Jamf runs as root, thus whoami it not suitable here
​
# 2. Set up logging
LOG_FILE="/var/log/user_avatar.log" # Jamf has enough permissions to write there
​
# Function to log messages with timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}
​
log "========================================"
log "Starting SMB share connection script"
log "Current user: $USERNAME"
​
# Define share details
SHARE_URL="smb://SHARENAME"
MOUNT_POINT="/Volumes/SHARENAME"
TIMEOUT=300  # seconds (5 minutes to allow time for credential entry)
​
# 3. Connect to the share (prompts for credentials, waits for authentication)
log "Opening $SHARE_URL to prompt for credentials..."
open "$SHARE_URL"
​
# Wait for the share to successfully mount AND authenticate
log "Waiting for share to mount with successful authentication..."
ELAPSED=0
AUTHENTICATED=false
​
while [ $ELAPSED -lt $TIMEOUT ]; do
    # Check three conditions to ensure successful mount AND authentication:
    # 1. Mount point directory exists
    # 2. It appears in the mount table (actually mounted)
    # 3. We can actually access the directory (proves authentication succeeded)
​
    if [ -d "$MOUNT_POINT" ] && \
       mount | grep -q "on $MOUNT_POINT" && \
       ls "$MOUNT_POINT" > /dev/null 2>&1; then
        AUTHENTICATED=true
        break
    fi
​
    sleep 1
    ELAPSED=$((ELAPSED + 1))
done
​
if [ "$AUTHENTICATED" = false ]; then
    log "ERROR: Share failed to mount or authentication failed within $TIMEOUT seconds. Exiting."
    exit 1
fi
​
log "SUCCESS: Share authenticated and mounted at $MOUNT_POINT"
​
# 4. Construct the file path with username variable - Check for numbered variants
log "Checking for available user folders..."
​
# Check for folders with numeric suffixes (_1 through _10) and the base folder
HIGHEST_FOLDER=""
HIGHEST_NUMBER=0
​
# First check if base folder exists (no suffix)
if [ -d "$MOUNT_POINT/PHOTOSDIR/$USERNAME" ]; then
    HIGHEST_FOLDER="$MOUNT_POINT/PHOTOSDIR/$USERNAME"
    HIGHEST_NUMBER=0
    log "Found base folder: $USERNAME"
fi
​
# Check for numbered variants from _1 to _10
for i in {1..10}; do
    CHECK_PATH="$MOUNT_POINT/PHOTOSDIR/${USERNAME}_${i}"
    if [ -d "$CHECK_PATH" ]; then
        log "Found folder: ${USERNAME}_${i}"
        if [ $i -gt $HIGHEST_NUMBER ]; then
            HIGHEST_FOLDER="$CHECK_PATH"
            HIGHEST_NUMBER=$i
        fi
    fi
done
​
# Validate that we found at least one folder
if [ -z "$HIGHEST_FOLDER" ]; then
    log "ERROR: No user folder found for $USERNAME (checked base and _1 through _10). Exiting."
    exit 1
fi
​
# Construct the final file path
FILE_PATH="$HIGHEST_FOLDER/photo.jpg"
​
if [ $HIGHEST_NUMBER -eq 0 ]; then
    log "Using base folder: $USERNAME"
else
    log "Using folder with highest number: ${USERNAME}_${HIGHEST_NUMBER}"
fi
​
log "Target file path: $FILE_PATH"
​
# Verify the file exists and is accessible
if [ ! -f "$FILE_PATH" ]; then
    log "ERROR: File not found at $FILE_PATH. Exiting."
    exit 1
fi
​
if ! cat "$FILE_PATH" > /dev/null 2>&1; then
    log "ERROR: Cannot read file at $FILE_PATH. Access denied. Exiting."
    exit 1
fi
​
log "File verified and accessible"
​
# 5. Download the file
DOWNLOAD_DIR="/Users/$USERNAME/Desktop"
log "Downloading file to $DOWNLOAD_DIR..."
​
if cp "$FILE_PATH" "$DOWNLOAD_DIR/"; then
    log "SUCCESS: File downloaded to $DOWNLOAD_DIR/photo.jpg"
else
    log "ERROR: Failed to download file. Exiting."
    exit 1
fi
​
# 6. Delete currently used photo and format the new photo
log "Removing previous photo and its directory"
dscl . delete /Users/$USERNAME JPEGPhoto
dscl . delete /Users/$USERNAME Picture
log "Cleared"
sleep 3
​
# 7. Copy new avatar to User Pictures where avatars are stored
log "Formatting new photo"
cp /Users/$USERNAME/Desktop/photo.jpg /Library/User\ Pictures/photo.heic
log "New photo successfully formatted"
sleep 3
​
# 8. Set new avatar
log "Setting new photo"
dscl . create /Users/$USERNAME Picture /Library/User\ Pictures/photo.heic && chmod 644 /Library/User\ Pictures/photo.heic
STATUS=$?
​
if [ $? -eq 0 ]; then
    log "New photo successfully set"
else
    log "Failed to set new photo"
fi
​
# 9. Desktop cleanup
log "Removing downloaded source picture"
rm -f /Users/$USERNAME/Desktop/photo.jpg
log "Picture removed"
​
log "Script completed successfully"
log "========================================"
