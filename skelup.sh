#!/bin/bash

#COPY ALL MODIFIED FILES IN SKEL DIRECTORY TO ALL HOME DIRECTORIES


for user in /home/*;
do


logger -t onboarding "Change detected in main skeleton directory on $(date)"
logger -t onboarding "Syncing files for all general staff"


    rsync -a --delete /etc/skel /home/$user/
    logger -t onboarding "Syncing Complete: Home directories has been updated for all general staff."




done 
