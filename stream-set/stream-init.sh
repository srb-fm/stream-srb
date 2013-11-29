#!/bin/bash
# generic init file for darkice
#
# Niels Dettenbach - nd@syndicat.com - 2009-11-05
# Last Change: 2010-12-21
#
# thanks to:
#   - Roland Whitehead
# GPL (2009)
# 0.7
#
# added functionality to restart darkice when errors occure
# by 
# Joerg Sorge, joergsorge at gmail.com, 2013-03-10
#
#
# config
configfile="/home/$USER/stream-srb/stream-set/stream-config.sh"

## do not edit below this line
source $configfile
# used variables from configfile
#program=/usr/bin/darkice
#pidfile=/home/$USER/stream-srb/stream-set/darkice-intern.pid
#configfile=/home/$USER/stream-srb/stream-set/stream-intern.cfg
#logfile=/home/$USER/stream-srb/stream-log/stream-intern.log
#progname="darkice"
#restart_delay=2
#verbose="5"
pidfile=$pidfile_int
## end of settings ##

RETVAL=0
if [ ! -f $configfile ]
then
	echo "$progname: config file not found"
	exit
fi

if [ ! -f $program ]
then
        echo "$progname: programm file $program not found"
        exit
fi

case $1 in
'start')
	if [ -f $pidfile ]; then
                PID=`cat $pidfile`
                running=`ps --no-headers -o "%c" -p $PID`
                if ( [ "$progname" == "$running" ] ); then
			echo "$progname is still running"
		else
			echo "$progname seems crashed - PID ($PID) does not match the deamon"
			echo "removing stale PID File $pidfile"
			rm -f $pidfile
			$0 start
			exit $?
		fi
		exit 0
	else
		echo -n $"Starting $progname "
		RETVAL=1
		# added by joergsorge: archive logfile
		if ( [ -f $logfile ] ); then
		        echo "\nsave $logfile to $logfile_archive"
			cp $logfile $logfile_archive
			rm $logfile
		fi
		# end archive logfile
		$program -v $verbose -c $configfile 2>%1 >> $logfile &
		echo
		RETVAL=$?
		if [ $RETVAL -eq 0  ]; then
        	        echo $! > $pidfile
        	        echo " started"
		else
			echo " not started"
			echo $RETVAL
			exit 0
		fi
		RETVAL=$?
	fi
;;
'stop')
	if [ -f $pidfile ]; then
		echo -n $"Stop $progname "
		PID=`cat $pidfile` 
		kill -s TERM $PID 2> /dev/null
		echo
		sleep $restart_delay
		rm -f $pidfile
		echo " stopped"
	else
		echo "$progname not running"
	fi
	RETVAL=$?
;;
'status')
	if [ -f $pidfile ]; then
		PID=`cat $pidfile` 		
		running=`ps --no-headers -o "%c" -p $PID`
		if ( [ "$progname" == "$running" ] ); then
			echo "$progname IS running with PID `cat $pidfile`."
		else
			echo "$progname process is dead or stale PID File $pidfile"
			exit 0
		fi
	else
		echo "$progname is not running"
		exit 0
	fi
;;
'restart')
	$0 stop
	$0 start
	RETVAL=$?
;;

'restartifdown')
	if [ -f $pidfile ]; then
                PID=`cat $pidfile`
                running=`ps --no-headers -o "%c" -p $PID`
                if ( [ "$progname" == "$running" ] ); then
                        echo "$progname IS running with PID `cat $pidfile` - no restart."
                else
			echo "$progname PID $PID seems dead - restart"
			$0 stop
        		$0 start
        		RETVAL=$?
		fi
	else
		echo "PID file $pidfile found - restart"
		$0 stop
		$0 start
		RETVAL=$?
	fi
;;

*)
	echo "Usage: $0 {start|stop|restart|status|restartifdown} "
	exit 1;
;;
esac

exit $RETVAL

