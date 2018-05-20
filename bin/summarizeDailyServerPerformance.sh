#!/bin/bash
# Use 'pmonitor-tools' to log summaries of the previous days web and db server performance
# Script to be run from cron job

if [ -z "$ACTIVELMSSERVERS" ]
then
	export ACTIVELMSSERVERS='12345'
fi

# Yesterdays date formatted for use in the pmonitor tools
if [ `date --date='yesterday' '+%d'` -lt "10" ]
then
	YST=`date --date='yesterday' '+%a %b%_d'`
else
	YST=`date --date='yesterday' '+%a %b %d'`
fi

# Check for command line parameters
until [ -z "$1" ]
do
	# if a date is passed in use it instead of yesterdays date
	if [[ "$1" =~ Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec ]]
	then
		YST=$1
	fi
	shift
done

# Directory to store the files in
PERFLOGDIR=/home/lbrieden/server_performance_logs

# Filename for log file
LOGFILE=$PERFLOGDIR/`date --date="$YST" '+%Y%m%d'`_server_performance

echo "Server load for $YST" > $LOGFILE
~/bin/pmonitor-uniqloadavg "$YST" avg >> $LOGFILE

# Database threads logging has been fixed, but not sure it makes sense to start adding it to the daily summary now
#echo "Database threads" >> $LOGFILE
#~/bin/pmonitor-uniqloadavg "$YST" db >> $LOGFILE

echo "Server load split by webserver" >> $LOGFILE
~/bin/pmonitor-uniqloadavg "$YST" split avg >> $LOGFILE

echo "Server load split by hour" >> $LOGFILE
for h in {00..23}
do
	echo "hour $h" >> $LOGFILE
	~/bin/pmonitor-uniqloadavg "$YST $h:" avg >> $LOGFILE
done

# Database threads logging has been fixed, but not sure it makes sense to start adding it to the daily summary now
#echo "Database threads split by hour" >> $LOGFILE
#for h in {00..23}
#do
	#echo "hour $h" >> $LOGFILE
	#~/bin/monitor-uniqloadavg "$YST $h:" db >> $LOGFILE
#done

TTB=$(~/bin/pmonitor-tooBusy "$YST" sh)
if [ "$TTB" = "" ]
then
	echo "Times we were too busy: 0" >> $LOGFILE
else
	echo "Times we were too busy: "$(echo "${TTB}" | wc -l) >> $LOGFILE
	echo "${TTB}" >> $LOGFILE
fi
