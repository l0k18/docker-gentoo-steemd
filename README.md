# docker-gentoo-steemd
`steemd` built inside a Docker container using a Gentoo base with size optimization

In the `dkr` directory is a short shell script that sets some handy aliases, which you
will need to run this docker container:

    cd dkr
    source init

Then you can type `halp` and it will show you the short commands to perform all the 
functions:

        dkr  "sudo docker"
       .run  "sudo docker run -v ~/steemd/data:/work -d  true --name steemd -t steemd"
     .enter  "sudo docker exec -it steemd bash"
       .log  "sudo docker logs --tail  30 -f steemd"
      .stop  "sudo docker stop steemd"
        .rm  "sudo docker rm steemd"
     .build  "sudo docker build -t steemd ."

I usually string these commands together when I am developing the Dockerfile, so
to build it, if it was already built and you have changed the Dockerfile, you will need
to run it like this:

    .stop;.rm;.build

which will stop the existing one with the name (by default in the init file, it is
`docker-gentoo-steemd`), remove the FS layers and start a build.

By default it starts up a No-Op command so you can manually enter to start up `steemd`,
but you can change this to automatically start steemd in the last line of the Dockerfile.
To run and enter the container:

    .run;.enter

The data directory contains a volume that is mounted inside the container as `/work`
which I have done so you can easily import `block_log` files or even the whole
`blockchain` folder inside `witness_node_data_dir`. However, note that this by default
will build v0.17.1 so an older `shared_memory.*` file will not work.

The other advantage of this arrangement is that even if you delete the Docker 
container, you won't lose the block_log and configuration files.

If you build and then enter and run `steemd` it will function as a seed node only, but
the config.ini does not specify a listen port (it will pick a random high port)
nor is the Dockerfile configured to forward any ports inbound. However, it should be
possible to have it replay, or sync up to date, and then you can stop it and add
a witness account name and signing key.

This is a super simple, minimalistic docker container, designed in the way that *I* do
things, which is usually different to other people. I think it is simpler and more
efficient.

The configuration of the Gentoo system inside the container is built with `-Os` 
compiler optimisation flag enabled, so that most of the support libraries are probably
smaller and faster than the ones that the host system ould use. Neither Boost nor 
steemd is optimised this way, however. I may amend this in the future, but for
now, this container is fully working and has a side benefit that following the 
commands inside the Dockerfile you can also build `steemd` to run on a Gentoo server.
