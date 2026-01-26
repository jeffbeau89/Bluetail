#!/bin/bash

#READ FILE WITH LIST OF STRINGS (i.e. John Doe Hr)
#CREATE USER FOR EACH STRING WITH FORMAT "FIRST INITIAL,LAST NAME" (i.e. jdoe)
#ADD SECONDARY GROUP USING 3RD FIELD IN STRING (i.e. hr)
#IF THIRD STRING NOT PRESENT ADD USER TO REG GROUP


#name=$(tail -1 /bluetail/employees | cut -d" " -f1-2)
#DEPT=$(tail -n 1 /bluetail/employees | cut -d" " -f3)
#USER=$(tail -1 /bluetail/employees | awk '{



name=$(diff /bluetail/employees /bluetail/employees.bak | awk '/^> / {sub("^> ", ""); print}')
DEPT=$(echo $name | cut -d" " -f3)
USER=$(echo $name | awk '{
        if (NF >= 2) {
           firstn = $1 #First name
           lasti = substr($2,1,1) #Last intial
           print tolower(firstn) tolower(lasti)
   }
}')

for new in "$USER"; do

        if grep -iq "$name" /bluetail/employees; then


                if [[ -n "$DEPT" ]]; then

#       logger -t onboarding "There has been a change to "$name"'s employment status"

                        useradd -G $DEPT -m -k /bluetail/$DEPT $USER
                        echo "$name was hired $(date), and was assigned the username: $USER." >> /home/user/change.log
			 echo "User: $new has been added to $DEPT department" >> /home/user/change.log
                        echo "$DEPT files added to $USER's home directory." >> /home/user/change.log
                else
                        useradd -G REG $USER
                        echo "$name was hired $(date), and was assigned the username: $USER." >> /home/user/change.log
                        echo "User: $new has been added to $DEPT department." >> /home/user/change.log
                        echo "$DEPT files added to $USER's home directory." >> /home/user/change.log
                fi

        else

		 logger -t onboarding "$name has been terminated and username $USER has been removed from the system"
                userdel -f  $USER
                #echo "$name has been terminated and username $USER has been removed from the system" >> /home/user/change.log

        fi
done

cp -f /bluetail/employees /bluetail/employees.bak

