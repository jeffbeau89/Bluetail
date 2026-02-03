#!/bin/bash

#READ FILE WITH LIST OF STRINGS (i.e. John Doe Hr)
#CREATE USER FOR EACH STRING WITH FORMAT "FIRST INITIAL,LAST NAME" (i.e. jdoe)
#ADD SECONDARY GROUP USING 3RD FIELD IN STRING (i.e. hr)
#IF THIRD STRING NOT PRESENT ADD USER TO REG GROUP

diff_output=$(diff /bluetail/employees /bluetail/employees.bak | awk '/^[<>] / { print}')




if [ -n "$diff_output" ]; then
	echo "$diff_output" > /bluetail/employ.temp
 	logger -t onboarding "Onboarding Initiated."


 	while IFS= read -r e; do
		name=$(echo "$e" | cut -d" " -f2-3)
		dept=$(echo "$e" | cut -d" " -f4)
		user=$(echo "$e" | awk '{
		        if (NF >= 2) {
       		           	firstn = $2 #First name
           			lasti = substr($3,1,1) #Last intial
           			print tolower(firstn) tolower(lasti)
  		     		     }
	       	       		       }')


        	if id "$user" &>/dev/null; then
			
				userdel -f  "$user"
				logger -t onboarding "There has been a change to "$name"'s employment status"
  				logger -t onboarding ""$name" has been terminated and username "$user" has been removed from the system"

		elif [[ -z "$dept" ]]; then


                        	useradd -G REG -c "$name" "$user"
                                logger -t onboarding ""$name" was hired $(date), and was assigned the username: "$user"."
                                logger -t onboarding "User: "$user" has been added to $dept department."
                                logger -t onboarding "All "$dept" files have been added to $user's home directory."

		elif [[ $dept == "ADMIN" ]]; then

				
				useradd -G "$dept,wheel" -c "$name" -m -k /bluetail/"$dept" "$user"
                                logger -t onboarding ""$name" was hired $(date), and was assigned the username: "$user"."
                                logger -t onboarding "User: "$user" is now an administrator and root access has been granted."
                                logger -t onboarding "All "$dept" files have been added to "$user"'s home directory."


		else
			
				 useradd -G "$dept" -c "$name" -m -k /bluetail/"$dept" "$user"
                                logger -t onboarding ""$name" was hired $(date), and was assigned the username: "$user"."
                                logger -t onboarding "User: "$user" has been added to "$dept" department"
                                logger -t onboarding "All "$dept" files have been added to "$user"'s home directory."

                fi

		

	done < /bluetail/employ.temp


else
	logger -t onboarding "Employees file was accessed, but no changes were made. Terminating Onboarding."

fi






cp -f /bluetail/employees /bluetail/employees.bak

