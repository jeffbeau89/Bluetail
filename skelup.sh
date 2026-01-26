#!/bin/bash

#COPY ALL MODIFIED FILES IN SKEL DIRECTORY TO ALL HOME DIRECTORIES

echo "/etc/skel was updated $(date)" >> /home/user/change.log

for dest in /home/*;
do
	find /etc/skel -type f -mmin -10 -exec cp {} $dest \;
done 
