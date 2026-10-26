#!/bin/bash

# ============================================================================
# Local Admin Rights Restoration Script v2
# ============================================================================

# Get the username and store in variable
USERNAME=$(users) # Jamf runs as root, thus whoami it not suitable here

# Set up logging
LOG_FILE="/var/log/restore_admin_rights.log"

# Function to log messages with timestamp
log() {
    echo "[$(date ‘+%Y-%m-%d %H:%M:%S’)] $1" | tee -a "$LOG_FILE"
}

log "========================================"
log "Starting admin rights restoration script"
log "Target user: $USERNAME"

# Check if the user exists
log "Validating username"
if ! id "$USERNAME" &>/dev/null; then
    log "ERROR: User $USERNAME not found. Exiting"
    exit 1
else
    log "User $USERNAME found. Continuing execution"
fi

# Add the user to the gid 80 admin group
log "Starting local admin rights restoration for $USERNAME"
dseditgroup -o edit -a "$USERNAME" -t user admin

# Check if the user was successfully added to the admin group
if [ $? -eq 0 ]; then
    log "$USERNAME was successfully added to the admin group"
else
    log "ERROR: Failed to add $USERNAME to the admin group"
fi

log "Script completed successfully"
log "========================================"
