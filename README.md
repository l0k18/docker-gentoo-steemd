# docker-gentoo-steemd
`steemd` built inside a Docker container using a Gentoo base with size optimization

In the `dkr` directory is a short shell script that sets some handy aliases, which you
will need to run this docker container:

    cd dkr
    source init.sh

Then you can type `halp` and it will show you the short commands to perform all the 
functions. The script stores its own location automatically so all commands will work 
no matter where you move in your filesystem. The script can be edited with the command:
`.editsh`. Note that the halp command simply processes the script itself to produce
the output, the code is the documentation, is the code.

Because it can be a bit confusing (it confused me for a long time) I will explain the
basic procedure to using this, beyond what the help in the `init.sh` provides:

To build the image, `.build` will run the procedure defined in the `Dockerfile`. Then
there will be an image you can see with `dkr ps -a` (probably at the top of the output).

To get the image running, type `.run` (this will also start the `steemd` which, with an empty `data`
folder will begin syncing from scratch, and use an empty configuration). There is
a file in `data/witness_node_data_dir/` called config.ini.example which will help
you create a basic witness configuration, I have annotated it with comments to
explain what you need to put in.

It is confusing, but `.run` is very different to `.start`. The former initialises 
a newly built container and starts it up, the latter starts an already initialised
container again after you have stopped it. It will complain if you try to `.run`
after `.run` has already been issued, and will only work if you `.stop` and `.rm`
to remove the container. Then you will have to `.build` again. This is what you
want to do if you edit the `Dockerfile`.

`.stop` will stop a running container, `.start` will start it again. `.log` will
show you the log file output, which is created in `data/steemd.sh` and is there
so that other scripts can monitor and parse the log file. If you use the 
`sudo docker <image name> logs` file instead, you will see a notice that the
logs are going to a log file and how to view them as they come down.

`.enter` will let you run a shell inside the container and poke around if you want
to do that (any changes will be lost on a `.stop;.rm;` though the contents of 
`/work` are persistent outside of the container.

The advantage of this arrangement is that even if you delete the Docker
container (not this folder), you won't lose the block_log and configuration files.

The data directory contains a volume that is mounted inside the container as `/work`
which I have done so you can easily import `block_log` files or even the whole
`blockchain` folder inside `witness_node_data_dir`. However, note that this by default
will build v0.17.1 so an older `shared_memory.*` file will not work.

Lastly, in my `init.sh` script you also have two commands, one, `.editsh` lets you
edit the `init.sh` file (after you first run it from the `dkr/` directory it will
remember even if you edit it where it is) and the other is `.editdkr` which will
let you edit the `Dockerfile`.

This is a super simple, minimalistic docker container, designed in the way that *I* do
things, which is usually different to other people. I think it is simpler and more
efficient.

The configuration of the Gentoo system inside the container is built with `-Os` 
compiler optimisation flag enabled, so that most of the support libraries are probably
smaller and faster than the ones that the host system would use. Neither Boost nor 
steemd is optimised this way, however. I may amend this in the future, but for
now, this container is fully working and has a side benefit that following the 
commands inside the Dockerfile you can also build `steemd` to run on a Gentoo server.

You may notice several shell and python scripts in the root of this directory, these
are not fully documented yet but are used to monitor a witness's log file using SSH,
and using the file `config` your primary and secondary keys and various other things,
for the script `monitor.sh` to use for your specific keys. `config.py` contains
configurations for the `switch.py` command which sends a broadcast of the update_witness
command which is used to switch over in the event of a primary witness node going offline
or ceasing to operate and update its log file. I will complete these soon, including
instructions on installing the prerequisites they need.
