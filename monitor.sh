#!/bin/bash
source config
    
while true
do
  if ! ping -c1 $URL &>/dev/null || (( `ssh -p 8008  $URL 'echo $(($(date +%s) - $(date +%s -r /home/loki/docker-gentoo-steemd-primary/data/steemd.log )))'` > 45 ))
  then
    echo "Last modified date more than 45 seconds ago, or unresponsive to ping - switching to secondary"
    #WITNESS=$WITNESS WIF=$WIF ./switch
    exit 0
  fi  
  echo "[`date +%Y%m%d%H%M%S`] Seconds since last log entry: `ssh -p 8008  $URL 'echo $(($(date +%s) - $(date +%s -r /home/loki/docker-gentoo-steemd-primary/data/steemd.log )))'`"
  echo "[`date +%Y%m%d%H%M%S`] Server responded to ping test"
  sleep 5
done
