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

# in this path audios to be recorded
path_stream_rec="/home/$USER/stream-srb/stream-record"

# path and filename for process-id of darkice
pidfile_int="/home/$USER/stream-srb/stream-set/darkice.pid"

# jack-source for streaming
jack_source_1="system:capture_1"
jack_source_2="system:capture_2"

# settings for stream-init.sh
program=/usr/bin/darkice
configfile=/home/$USER/stream-srb/stream-set/stream-darkice.cfg
logdir=/home/$USER/stream-srb/stream-log
logfile=/home/$USER/stream-srb/stream-log/stream.log
progname="darkice"
restart_delay=2
verbose="5"