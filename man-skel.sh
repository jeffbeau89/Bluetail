#!/bin/bash

#EVERYONE IN THIS GROUP HAS AN UNIQUE SKELETON FOLDER
#COPY ALL FILES IN THE FOLDER THAT HAVE BEEN RECENTLY MODIFIED AND SEND THEM TO ALL THE USERS IN THAT GROUP


GROUP="MANG"

USERS=$(getent group "$GROUP" | cut -d: -f4 | cut -d, -f1- | tr ',' '\n')
#echo $USERS


echo "Change detected in $GROUP directory on $(date)" >> /home/user/change.log
echo "Syncing files for all users in $GROUP group" >> /home/user/change.log

for user in $USERS;
do
   
    rsync -a --delete /bluetail/$GROUP/ /home/$user/
    echo "$user's Home Directory has been synced with $GROUP directory." >> /home/user/change.log

    #rsync is more effecient than find command in this scenario, as it can both copy delete necessary files
    #find /bluetail/MANG -type f -mmin -10 -exec cp {} /home/$user \;

done




