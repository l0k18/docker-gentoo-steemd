export NAME="docker-gentoo-steemd" #NOPRINT
if [[ -z $DATADIR ]]; then #NOPRINT
  export DATADIR="`cd ..;pwd`" #NOPRINT
fi #NOPRINT
source $DATADIR/config #NOPRINT
echo "Loading command aliases... Type 'halp' to see available commands" #NOPRINT
# HALP! How to control your $NAME docker container

alias      dkr="sudo docker"
         ### [ shortcut to run docker with sudo ]
alias   .where="echo $DATADIR"
         ### [ show where the current instance activated by init.sh lives ]
alias     .run="sudo docker run -v $DATADIR/data:/work -d=true --name $NAME $NAME"
         ### [ start up the container (after building, to restart. for a'.stop'ed container, use '.start') ]
alias   .start="sudo docker start $NAME"
         ### [ start the container that was previously '.stop'ed ]
alias    .stop="sudo docker stop $NAME"
         ### [stop the container, start it again with '.start']
#NOPRINT alias   .steem="sudo docker exec -it $NAME steemd"
#NOPRINT         ### [start up steemd inside the container attached to current terminal]
alias  .status="ps avx|grep steemd|grep -v grep|grep -v zsh|grep -v docker"
         ### display process information about all steemd's running on this server
alias   .enter="sudo docker exec -it $NAME bash"
         ### [open a shell inside the container]
alias     .log="sudo tail -f $DATADIR/data/steemd.log"
         ### [show the current output from the primary process in the container]
alias   .build="sudo docker build -t $NAME $DATADIR/dkr"
         ### [build the container from the Dockerfile]
alias      .rm="sudo docker rm $NAME"
         ### [remove the current container (for rebuilding)]
alias .editdkr="nano $DATADIR/dkr/Dockerfile"
         ### [edit the Dockerfile]
alias  .editsh="nano $DATADIR/dkr/init.sh;source $DATADIR/dkr/init.sh"
         ### [edit init.sh with nano then reload]
alias  halp="sed 's/\$NAME/$NAME/g' $DATADIR/dkr/init.sh|sed 's#\$DATADIR#$DATADIR#g'|grep -v NOPRINT|sed 's/alias //g'|sed 's/=\"/     \"/g'|sed 's/#/>/g'"
