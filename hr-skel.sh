#!/bin/bash

#EVERYONE IN THIS GROUP HAS AN UNIQUE SKELETON FOLDER
#MAKE SURE THE HOME DIRECTORIES OF ALL GROUP MEMBERS ARE ALWAYS SYNCED WITH THE FILES IN THE SKELETON DIRECTORY:


GROUP="HR"

USERS=$(getent group "$GROUP" | cut -d: -f4 | cut -d, -f1- | tr ',' '\n')
#echo $USERS


logger -t onboarding "Change detected in "$GROUP" directory."
logger -t onboarding "Syncing Initiated for all "$GROUP" department members."
logger -t onboarding "Home Directory is being updated for the following users:"

for user in $USERS;
do

    rsync -a --delete /bluetail/$GROUP/ /home/$user/
    logger -t onboarding "$user"


    #ORIGINALLY: find /bluetail/HR -type f -mmin -1 -exec cp {} /home/$user \;
    #rsync is more effecient than find command in this scenario, as it compare directories and can both copy delete necessary files
    #In return syncs the target directory with the skeleton directory.
    #The "-mmin -1" option can cause duplicates if skeleton directory is updated multiple times within a minute.

done

logger -t onboarding "Syncing Complete. $(date)"

~
~
