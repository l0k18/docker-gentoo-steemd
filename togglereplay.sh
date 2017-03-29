#!/bin/bash
if [ ! -f $DATADIR/.replay ]
then
  echo 'Enabling replay mode'
  echo 'CMD steemd --replay 1>>/work/steemd.log 2>>/work/steemd.log'>>$DATADIR/dkr/Dockerfile
  touch $DATADIR/.replay
  sudo docker stop $NAME
  sudo docker rm $NAME
  sudo docker build -t $NAME $DATADIR/dkr
  echo "type '.run' to begin replay"
else
  echo 'Disabling replay mode'
  head -n -1 $DATADIR/dkr/Dockerfile>$DATADIR/dkr/Dockerfile.replay
  rm $DATADIR/dkr/Dockerfile
  mv $DATADIR/dkr/Dockerfile.replay $DATADIR/dkr/Dockerfile
  rm $DATADIR/.replay
  sudo docker stop $NAME
  sudo docker rm $NAME
  sudo docker build -t $NAME $DATADIR/dkr
  echo "type '.run' to restart with replay disabled"
fi

