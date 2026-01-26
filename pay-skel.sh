#!/bin/bash

#EVERYONE IN THIS GROUP HAS AN UNIQUE SKELETON FOLDER
#COPY ALL FILES IN THE FOLDER THAT HAVE BEEN RECENTLY MODIFIED AND SEND THEM TO ALL THE USERS IN THAT GROUP

echo "Payroll Documents last updated $(date)" >> /home/user/change.log

GROUP="PAYR"

USERS=$(getent group "$GROUP" | cut -d: -f4 | cut -d, -f1- | tr ',' '\n')
echo $USERS

for user in $USERS;
do
        echo "$user's Home Directory is now being updated"
    find /bluetail/PAYR -type f -mmin -10 -exec cp {} /home/$user \;
        echo "$user's Home Directory has been updated"

done
~
