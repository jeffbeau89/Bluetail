#!/bin/bash

#EVERYONE IN THIS GROUP HAS AN UNIQUE SKELETON FOLDER
#MAKE SURE THE HOME DIRECTORIES OF ALL GROUP MEMBERS ARE ALWAYS SYNCED WITH THE FILES IN THE SKELETON DIRECTORY:



USERS=$(getent group HR | cut -d: -f4 | tr ',' '\n')



logger -t onboarding "Change detected in HR directory."
logger -t onboarding "Syncing Initiated for all HR department members."
logger -t onboarding "Home Directory is being updated for the following users:"

while IFS= read -r user; do

    # Sync the HR directory to each user's home
    rsync -a --delete "/bluetail/HR/" "/home/$user/"

    # Log each user icnluded in sync
    logger -t onboarding "$user"
done <<< "$USERS"



logger -t onboarding "Syncing Complete. $(date)"


    #ORIGINALLY: find /bluetail/HR -type f -mmin -1 -exec cp {} /home/$user \;
    #rsync is more effecient than find command in this scenario, as it compare directories and can both copy delete necessary files
    #In return syncs the target directory with the skeleton directory.
    #The "-mmin -1" option can cause duplicates if skeleton directory is updated multiple times within a minute.
