#!/bin/bash
#
# This script is for starting darkice-stream and tools
# to stop darkice and tools use stream-stop.sh
#
# Prerequisite is a correct running jack/Qjackctrl
#
# Author: Joerg Sorge
# Distributed under the terms of GNU GPL version 2 or later
# Copyright (C) Joerg Sorge joergsorge at gmail.com
# 2013-03-20
#
# todo: 
# check if configfile
# jamin template
#
# config:
stream_config="/home/$USER/stream-srb/stream-set/stream-config.sh"



## do not edit below this line
source $stream_config

function f_check_configfile () {
	if [ ! -f $stream_config ]
	then
		message="# Configfile not found..\n$configfile\n Let's let down..."
		echo $message
		sleep 5
		exit
	fi
}

function f_check_log_dir () {
	if [ ! -d "$logdir" ]
	then
		message="$message Creating log-directory..\n$logdir\n"
		mkdir "$logdir"
		echo $message
		sleep 1
	fi
}

function f_check_rec_dir () {
	if [ ! -d "$rec_dir" ]
	then
		message="$message Creating log-directory..\n$rec_dir\n"
		mkdir "$rec_dir"
		echo $message
		sleep 1
	fi
}

function f_check_package () {
        package_install=$1
        if dpkg-query -s $1 2>/dev/null|grep -q installed; then
                echo "$package_install installiert"
        else
                zenity --error --text="Package:\n$package_install\nnot installt, please install it first!"
		./stream-stop.sh &
                exit
        fi
}


function f_start_meterbridge () {
	message="#$message Starting Meterbridge..\n"
	echo $message
	f_check_package "meterbridge"
	sleep 1
	meterbridge -t dpm -n stream-bridge x x &
	message="#$message Connecting Meterbridge..\n"
	echo $message
	sleep 2
	jack_connect $jack_source_1 stream-bridge:meter_1 &
	jack_connect $jack_source_2 stream-bridge:meter_2 &
}

function f_start_ebumeter () {
	message="$message Starting EBU Meter..\n"
	echo $message
	f_check_package "ebumeter"
	sleep 1
	ebumeter &
}

function f_check_jack () {
	message="$message Checking Jack..\n"
	echo $message
	sleep 1
	jack_pid=$(ps aux | grep '[q]jackctl' | awk '{print $2}')
	if [ "$jack_pid" == "" ]; then
		zenity --error --text="Qjackctl is not running!\n Please start it befor running this script!\n Let's lay down.."
		exit		
	fi
}

function f_check_jamin () {
	message="$message Check Jamin..\n"
	echo $message
	sleep 1
	jamin_pid=$(ps aux | grep '[j]amin' | awk '{print $2}')
	if [ "$jamin_pid" != "" ]; then
		zenity --error --text="Jamin is alraedy running!\n Please kill it befor using this script.."
		exit
	fi
}

function f_start_jamin () {
	message="$message Starting Jamin..\n"
	echo $message
	f_check_package "jamin"
	sleep 1
	jamin &
}

function f_connect_jamin () {
	message="$message Connect Jamin..\n"
	echo $message
	sleep 3
	jack_connect $jack_source_1 jamin:in_L &
	jack_connect $jack_source_2 jamin:in_R &
}

function f_start_audiorecorder () {
	message="$message Begin recording..\n"
	echo $message
	f_check_package "rotter"
	f_check_rec_dir
	sleep 1	
	rotter $rotter_set "$rec_dir" &
}

function f_start_stream_init () {
	message="$message Starting Stream..\n"
	echo $message
	f_check_package "darkice"
	sleep 1
	cd "$path_stream_tools"
	pmessage=$(./stream-init.sh start)
	message="$message\n$pmessage\n"
	echo $message
}

function f_connect_darkice () {
	message="$message Connect Darkice..\n"
	echo $message
	sleep 1
	# pid ermitteln
	pid_darkice=$(cat $pidfile_int)
	pdarkice="darkice-$pid_darkice"
	message="$message $pdarkice"
	echo $message
	jack_disconnect $jack_source_1 $pdarkice:left &
	jack_disconnect $jack_source_2 $pdarkice:right &
	jack_connect jamin:out_L $pdarkice:left &
	jack_connect jamin:out_R $pdarkice:right &
}


function f_start_watchdog () {
	message="$message Starting Watchdog..\n"
	echo $message
	sleep 1
	cd "$path_stream_tools"
	$terminal_type -x ./stream-watch.sh start &
}


echo "Starting Stream and Jack-Apps..."

(	echo "10"
	message="# Starting Tools..\n"
	f_check_configfile
	f_check_log_dir
	f_check_jack
	if [ "$jamin" != "n" ]; then
		f_check_jamin
	fi

	if [ "$meterbridge" != "n" ]; then
		f_start_meterbridge
	fi

	if [ "$ebumeter" != "n" ]; then
		f_check_ebumeter
	fi

	if [ "$jamin" != "n" ]; then
		f_start_jamin
		f_connect_jamin
	fi

	if [ "$recorder" != "n" ]; then
		f_start_audiorecorder
	fi	
	f_start_stream_init

	if [ "$jamin" != "n" ]; then
		f_connect_darkice
	fi

	f_start_watchdog
	sleep 5
	echo "100"
	
)| zenity --progress \
           --title="Stream" --text="starten..." --width=500 --pulsate --auto-close

