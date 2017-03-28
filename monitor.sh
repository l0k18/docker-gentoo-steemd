#!/bin/bash
source config

PINGFAIL=0

while true
do
  if ! ping -c1 $PRIMARYURL >/dev/null
  then
    PINGFAIL=$(( PINGFAIL + 1 ))
    echo "`date +%Y-%m-%d_%H:%M:%S` Witness server not responding to ping. Failover after 25 seconds"
    if (( $PINGFAIL > 5 ))
    then
      echo "`date +%Y-%m-%d_%H:%M:%S` Witness server not responding to ping for 25 seconds. Switching to secondary"
      ./switch.py
      exit 1
    fi
  else
    PINGFAIL=0
    if (( (( `date +%s` - `ssh -p $PRIMARYPORT $PRIMARYURL date +%s -r $LOGFILE` )) > $THRESHOLD ))
    then
      echo "`date +%Y-%m-%d_%H:%M:%S` Log file is more than $THRESHOLD seconds old. Switching to secondary"
      ./switch.py
      exit 1
    else
      echo "`date +%Y-%m-%d_%H:%M:%S` Witness server up and log less than $THRESHOLD seconds old"
    fi
  fi
  sleep 5
done
