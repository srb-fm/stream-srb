#!/bin/bash
#
# This script is for stopping darkice-stream and tools
# wich are started with stream-start.sh
#
# Author: Joerg Sorge
# Distributed under the terms of GNU GPL version 2 or later
# Copyright (C) Joerg Sorge joergsorge at gmail.com
# 2013-03-20
#

# config:
stream_config="/home/$USER/stream-srb/stream-set/stream-config.sh"

## do not edit below this line
source $stream_config
echo "Stream Jack-Apps-stopping..."

(	echo "10"

	cd "$path_stream_tools"

	echo "# Watchdog stop.."
	sleep 1
	killall stream-watch.sh &
	
	echo "# Stream stop.."
	sleep 1
	message=$(./stream-init.sh stop)
	echo "# $message"

	if [ "$recorder" != "n" ]; then
		echo "# Audio-Recorder stop.."
		sleep 1	
		killall rotter &
	fi
	
	if [ "$jamin" != "n" ]; then
		echo "# Jamin stop.."
		sleep 1	
		killall jamin &
	fi

	if [ "$calffx" != "n" ]; then
		echo "# Calfjackhost stop.."
		sleep 1	
		killall calfjackhost &
	fi

	if [ "$meterbridge" != "n" ]; then
		echo "# Meterbridge stop.."
		sleep 1
		killall meterbridge &
	fi	
	
	if [ "$ebumeter" != "n" ]; then
		echo "# EBU Meter stop.."
		sleep 1
		killall ebumeter &
	fi

	sleep 2
	echo "100"

)| zenity --progress \
           --title="SRB-Stream" --text="stop..." --width=500 --pulsate --auto-close

