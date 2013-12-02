#!/bin/bash

## settings ##
# check your paths!
configfile="/home/$USER/stream-srb/stream-set/stream-config.sh"

source $configfile

#logfile=comes from $configfile
error_msg="failed to write to ring"
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
	if grep "$error_msg" "$logfile" 
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
		echo -e "$(date +'%y-%m-%d-%H-%M-%S') Keine Verbindung zu Server \nstopp darkice"
		./stream-init.sh stop
	fi

	if [ $darkice_error -gt 0 ]
	then
		echo -e "$(date +'%y-%m-%d-%H-%M-%S') Fehler gefunden \nstopp darkice"
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
