#!/bin/bash
#
# This script is for watching darkice-errors
# It uses stream-init.sh to start and stop darkice
#
# Thankx to Niels Dettenbach
#
# Author: Joerg Sorge
# Distributed under the terms of GNU GPL version 2 or later
# Copyright (C) Joerg Sorge joergsorge at gmail.com
# 2013-03-20
#
#
## settings ##
# check your paths!
configfile="/home/$USER/stream-srb/stream-set/stream-config.sh"

source $configfile

#logfile=comes from $configfile
error_msg_0="failed to write to ring"
error_msg_1="encoding ends"
error_msg_2="lame lib opening underlying sink error"
error_msg_3="gethostbyname error"
darkice_error=0
watch_counter=0
error_counter=0
## end of settings ##

echo -e "Watchig for darkice-errors in \n$logfile \nType Ctrl+C to cancel " 
while (true) ; do
(	
	if grep "$error_msg_0" "$logfile" 
	then 
		((darkice_error+=1))
		((error_counter+=1))
	fi
	
	if grep "$error_msg_1" "$logfile" 
	then 
		((darkice_error+=1))
		((error_counter+=1))
	fi
	if grep "$error_msg_2" "$logfile" 
	then 
		((darkice_error+=1))
		((error_counter+=1))
	fi

	if grep "$error_msg_3" "$logfile" 
	then 
		echo -e "$(date +'%y-%m-%d-%H-%M-%S') No connect to Server \nstopp darkice"
		./stream-init.sh stop
	fi

	if [ $darkice_error -gt 0 ]
	then
		echo -e "$(date +'%y-%m-%d-%H-%M-%S') Found Error \nstopp darkice"
		./stream-init.sh stop
		echo "start stream..."
		sleep 6
		./stream-init.sh start
		darkice_error=0
	fi	
	sleep 5
	((watch_counter+=1))
) 
done
