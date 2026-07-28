#!/bin/bash

# Allows to remove a logged-in user from the local admins
# Can be run in an MDM policy as root
 
# ============================================================================ 
# Local Admin Rights Removal Script
# ============================================================================ 
 
# Get the username and store in variable 
USERNAME=$(users) # Jamf runs as root, thus whoami is not suitable here 
 
# Set up logging 
LOG_FILE="/var/log/remove_admin_rights.log"  
 
# Function to log messages with timestamp 
log() { 
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE" 
} 
 
log "========================================" 
log "Starting admin rights removal script" 
log "Target user: $USERNAME" 
 
# Check if the user exists 
log "Validating username" 
if ! id "$USERNAME" &>/dev/null; then 
    log "ERROR: User $USERNAME not found. Exiting" 
    exit 1 
else 
    log "User $USERNAME found. Continuing execution" 
fi 
 
# Remove the user from the gid 80 admin group 
log "Starting local admin rights removal from $USERNAME" 
dseditgroup -o edit -d "$USERNAME" -t user admin 
 
# Check if the user was successfully removed from the admin group 
if [ $? -eq 0 ]; then 
    log "$USERNAME was successfully removed from the admin group" 
else 
    log "ERROR: Failed to remove $USERNAME from the admin group" 
fi 
 
log "Script completed" 
log "========================================"
