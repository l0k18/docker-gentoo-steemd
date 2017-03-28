#!/bin/bash #NOPRINT
export NAME="docker-gentoo-steemd" #NOPRINT
export DATADIR="`dirname $(realpath $(dirname $0))`" #NOPRINT
source $DATADIR/config #NOPRINT
echo "Loading command aliases... Type 'halp' to see available commands" #NOPRINT

### HALP! How to control your $NAME docker container

alias      dkr="sudo docker"
         ### [ shortcut to run docker with sudo ]
alias   .where="echo $DATADIR"
         ### [ show where the current instance activated by init.sh lives ]
alias      .cd="cd $DATADIR"
         ### [ change working directory to instance folder ]
alias     .run="sudo docker run -v $DATADIR/data:/work -d=true --name $NAME $NAME"
         ### [ start up the container (after building, to restart. for a'.stop'ed container, use '.start') ]
alias   .start="sudo docker start $NAME"
         ### [ start the container that was previously '.stop'ed ]
alias    .stop="sudo docker stop $NAME"
         ### [ stop the container, start it again with '.start' ]
alias   .steem="sudo docker exec -it $NAME steemd"
         ### [ start up steemd inside the container attached to current terminal ]
alias  .status="ps avx|grep steemd|grep -v grep|grep -v zsh|grep -v docker"
         ### [ display process information about all steemd's running on this server
alias   .enter="sudo docker exec -it $NAME zsh"
         ### [ open a shell inside the container ]
alias     .log="sudo tail -f $DATADIR/data/steemd.log"
         ### [ show the current output from the primary process in the container ]
alias   .build="sudo docker build -t $NAME $DATADIR/dkr"
         ### [ build the container from the Dockerfile ]
alias      .rm="sudo docker rm $NAME"
         ### [ remove the current container (for rebuilding) ]
alias .editdkr="nano $DATADIR/dkr/Dockerfile"
         ### [ edit the Dockerfile ]
alias  .editsh="nano $DATADIR/dkr/init.sh;source $DATADIR/dkr/init.sh"
         ### [ edit init.sh with nano then reload ]
alias .editcfg="nano $DATADIR/config"
         ### [ edit environment variables ]
alias .editwit="nano $DATADIR/config.py"
         ### [ edit witness failover configuration ]
alias .monitor="screen -d -S monitor -m $DATADIR/monitor.sh" 
         ### [ start up primary witness failover script in a detached screen session ]
alias  .feeder="screen -d -S feeder -m $DATADIR/feeder.py"
         ### [ start up feed setter script in a detached screen session ]
alias  .screen="screen -r" # monitor or feeder <
         ### [ view feeder or monitor, name in the parameter. Ctrl-A then D to exit, Ctrl-C to kill process ]
alias  halp="sed 's/\$NAME/$NAME/g' $DATADIR/dkr/init.sh|sed 's#\$DATADIR#$DATADIR#g'|grep -v NOPRINT|sed 's/alias //g'|sed 's/=\"/     \"/g'|sed 's/#/>/g'|less"
######### hit the 'q' key to exit help viewer <<<<<<<<<
