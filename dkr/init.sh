#!/bin/bash
export NAME="docker-gentoo-steemd"
export DATADIR="`cd ..;pwd`"
echo "Loading command aliases... Type 'halp' to see available commands"
# HALP! How to control your $NAME Container
alias      dkr="sudo docker"
         ### [shortcut to run docker with sudo]
alias   .where="echo $DATADIR"
         ### [show where the current instance activated by init.sh lives]
alias     .run="sudo docker run -v $DATADIR/data:/work -d=true --name $NAME -t $NAME"
         ### [start up the container]
alias   .steem="sudo docker exec -it $NAME steemd"
         ### [start up steemd inside the container attached to current terminal]
alias   .enter="sudo docker exec -it $NAME bash"
         ### [open a shell inside the container]
alias     .log="sudo docker logs --tail=30 -f $NAME"
         ### [show the current output from the primary process in the container]
alias    .stop="sudo docker stop $NAME"
         ### [stop the container]
alias      .rm="sudo docker rm $NAME"
         ### [remove the current container (for rebuilding)]
alias   .build="sudo docker build -t $NAME ."
         ### [build the container from the Dockerfile]
alias    .edit="nano $DATADIR/dkr/Dockerfile"
         ### [edit the Dockerfile]
alias  .editsh="nano $DATADIR/dkr/init.sh;source $DATADIR/dkr/init.sh"
         ### [edit init.sh with nano then reload]
alias  .reload="source /home/loki/docker-gentoo-steemd/dkr/init.sh"
         ### [reload the init.sh]
alias  halp="sed 's/\$NAME/$NAME/g' $DATADIR/dkr/init.sh|sed 's#\$DATADIR#$DATADIR#g'|grep -v halp|grep -v export|grep -v bin\/bash|sed 's/alias //g'|sed 's/=\"/     \"/g'|sed 's/#/>/g'"
