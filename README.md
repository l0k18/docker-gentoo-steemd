# docker-gentoo-steemd
`steemd` built inside a Docker container using a Gentoo base with size optimization

In the `dkr` directory is a short shell script that sets some handy aliases, which you
will need to run this docker container:

    source init.sh

Note that you can 'source' this file from any other part of the filesystem and it will
still know where its' parent directory and all the bits are.

Then you can type `halp` and it will show you the short commands to perform all the 
functions. The script stores its own location automatically so all commands will work 
no matter where you move in your filesystem. The script can be edited with the command:
`.editsh`. Note that the halp command simply processes the script itself to produce
the output, the code is the documentation, is the code.

## Basic info about managing a Docker Witness instance

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

There is more commands now available in there, but the 'halp' command will provide enough
information to use most of them.

There is now a monitor script that can be used, and there is a command in the `init.sh`
that launches it inside a screen session detached. Copy or rename the `config.example`
and `config.py.example` to the same names without the `.example` ending and the monitor
script will have all the details. Some of the parameters are unneccessary in the current
configuration but I intend to add more functions that will use them (such as a manual
toggle between your primary and secondary witness).

There is also a price feed setter script that draws its numbers from coinmarketcap,
it also draws on the the same configurations, and note that the `init.sh` brings the
environment variables set in `config` into your environment along with all the aliases
to make managing a witness is nice and easy.

This is a super simple, minimalistic docker container, designed in the way that *I* do
things, which is usually different to other people. I think it is simpler and more
efficient.

The configuration of the Gentoo system inside the container is built with `-Os` 
compiler optimisation flag enabled, so that most of the support libraries are probably
smaller and faster than the ones that the host system would use. Neither Boost nor 
steemd is optimised this way, however. I may amend this in the future, but for
now, this container is fully working and has a side benefit that following the 
commands inside the Dockerfile you can also build `steemd` to run on a Gentoo server.

## Prerequisites

The accessory scripts in this package assume a number of prerequisites, which are mostly
generally already present. The exceptions are the python related stuff (not necessary for
the basic witness operation but for the feeder and monitor they are required)

For Ubuntu to install these prerequisites:

    sudo apt install python3 python3-pip screen
    sudo -H pip3 install asyncio requests piston-lib websockets

For other distros, like Arch linux, the information will be added in the near future.
