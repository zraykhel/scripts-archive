#!/bin/bash

# ==============================================================================
# Local Admin Rights Management Script
# ==============================================================================

# Get the username and store it in a variable
USERNAME=$(users) # Jamf runs as root, thus whoami it not suitable here

# Get the action from Jamf parameter (default to "add" if not specified)
ACTION="${4:-add}"

# Validate action parameter
if [[ ! "$ACTION" =~ ^(add|remove)$ ]]; then
    echo "ERROR: Invalid ACTION parameter. Use ‘add’ or ‘remove’. Received: $ACTION"
    exit 1
fi

# Set up logging based on action
if [[ "$ACTION" == "add" ]]; then
    LOG_FILE="/var/log/restore_admin_rights.log"
    ACTION_FLAG="-a"
    ACTION_VERB="restoration"»
    ACTION_PAST="added to"
    ACTION_PAST_ERROR="add"
else
    LOG_FILE="/var/log/remove_admin_rights.log"
    ACTION_FLAG="-d"
    ACTION_VERB="removal"
    ACTION_PAST="removed from"
    ACTION_PAST_ERROR="remove"
fi

# Function to log messages with timestamp
log() {
    echo "[$(date ‘+%Y-%m-%d %H:%M:%S’)] $1" | tee -a "$LOG_FILE"
}

log "======================================================"
log "Starting admin rights $ACTION_VERB script"
log "Target user: $USERNAME"

# Check if the user exists
log "Validating username"
if ! id "$USERNAME" &>/dev/null; then
    log "ERROR: User $USERNAME not found. Exiting"
    exit 1
else
    log "User $USERNAME found. Continuing execution"
fi

# Manage user in the gid 80 admin group
log "Starting local admin rights $ACTION_VERB for $USERNAME"
dseditgroup -o edit $ACTION_FLAG "$USERNAME" -t user admin

# Check if the user was successfully added/removed from the admin group
if [ $? -eq 0 ]; then
    log "$USERNAME was successfully $ACTION_PAST the admin group"
else
    log "ERROR: Failed to $ACTION_PAST_ERROR $USERNAME to the admin group"
fi

log "Script completed successfully"
log "======================================================"
