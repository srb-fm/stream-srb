#!/bin/bash
# This script is the configuration for starting darkice-stream and tools
# with 
# stream-start.sh and
# stream-stop.sh
#
# Author: Joerg Sorge
# Distributed under the terms of GNU GPL version 2 or later
# Copyright (C) Joerg Sorge joergsorge at gmail.com
# 2013-11-28
#
# config:
#
# path to stream-toolset
path_stream_tools="/home/$USER/stream-srb/stream-set"

# path for recording audios
rec_dir="/home/$USER/stream-srb/stream-record"

# path and filename for process-id of darkice
pidfile_int="/home/$USER/stream-srb/stream-set/darkice.pid"

# jack-source for streaming
jack_source_1="system:capture_1"
jack_source_2="system:capture_2"

# playback
#jack_out_1="system:playback_1"
#jack_out_2="system:playback_2"

# tools you will use (j/n)
jamin="n"
meterbridge="n"
recorder="j"
ebumeter="n"
calffx="j"

# settings for audiorecorder rotter (refer to the manpage of rotter)
rotter_set="-a -f mp3 -b 192 -v -L flat -N SRB_Prot"

# terminal you will use for watchdog
terminal_type="gnome-terminal"
#terminal_type="xfce4-terminal"

# settings for stream-init.sh
program=/usr/bin/darkice
configfile=/home/$USER/stream-srb/stream-set/stream-darkice.cfg
logdir=/home/$USER/stream-srb/stream-log
logfile=/home/$USER/stream-srb/stream-log/stream.log
logfile_archive="/home/$USER/stream-srb/stream-log/stream-$(date +'%y-%m-%d-%H-%M-%S').log"
progname="darkice"
restart_delay=2
verbose="5"
