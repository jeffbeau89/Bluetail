#!/bin/bash

#COPY ALL MODIFIED FILES IN SKEL DIRECTORY TO ALL HOME DIRECTORIES


USERS=$(getent group REG | cut -d: -f4 | tr ',' '\n')

logger -t onboarding "Change detected in main skeleton directory."
logger -t onboarding "Syncing Initiated for all general staff."
logger -t onboarding "Home Directory is being updated for the following users:"


while IFS= read -r user; do

    # Sync the /etc/skel directory to REG group user's home
    rsync -a --delete "/etc/skel/" "/home/$user/"

    # Log each user icnluded in sync
    logger -t onboarding "$user"
done <<< "$USERS"


    logger -t onboarding "Syncing Complete. $(date)"
