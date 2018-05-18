# Catapult Server Bootstrap

This repo contains a set of bootstrap and setup scripts to help developers get going quickly with their own working Catapult Server.  The goal is to make it as easy and quick as possible so as a developer you only have to run this setup and within a minute or so you will have a running server ready to start receiving transactions so you can focus on your development work and not setup or configuring servers.

We use docker images as our default packaging and distribution mechanism.  These bootstrap scripts will prepare some files on disk and then leverage docker-compose to startup and run the needed set of containers so the server can function correctly.

## Evironment Dependencies

The only dependency that is required is git so you can clone this repository, and docker/docker-compose.  If you do not have the docker tools installed alredy you can get the installation details from the docker community website:

[Docker Install Overview Page](https://docs.docker.com/install/#server)
[Docker Compose Install Overview Page](https://docs.docker.com/compose/install/#install-compose)

## Installation & Startup Instructions

1) `git clone git@github.com:tech-bureau/catapult-server-bootstrap.git`
2) `cd catapult-server-bootstrap`
3) `docker-compose up`

If you followed the docker installation instructions correctly, or already had docker/docker-compose installed, you should see docker doing its job downloading the container images for the first time, then going through running the bootstrap setup.  Should things succeed it should start the Catapult Server right up and you should see the live logs start scrolling by in the foreground like so:

```
api-node-0_1              | 2018-05-18 18:52:11.888098 0x00007f24efa20700: <debug> (src::NetworkHeightService.cpp@45) network chain height increased from 120 to 121
peer-node-1_1             | 2018-05-18 18:52:12.068932 0x00007fe59221c700: <debug> (src::NetworkHeightService.cpp@45) network chain height increased from 120 to 121
peer-node-0_1             | 2018-05-18 18:52:12.477647 0x00007f35d4de4700: <debug> (src::NetworkHeightService.cpp@45) network chain height increased from 120 to 121
```

You can verify things are running by doing a quick curl request to get block information: `curl localhost:3000/blocks/1`

To stop the server simply press `Ctrl+c` to kill/stop the foreground docker process.

## Keys Setup

The bootstrap scripts take care of initial key generation and config.  You can get the details of the key(s) that are being used in your test setup by going to:

---KEY INFO----

## Starting as a Background Process

With the initial setup steps above you installed and started your Catapult Server in the foreground, for ongoing development where you just want the server to be running its nice to have it running in the background.  You can do so by navigating back to your `catapult-server-bootstrap` directory and running `docker-compose up -d`

For more detailed usage of the `docker-compose up` command you can check out dockers community docs:

[Docker Compose Up Command Overview](https://docs.docker.com/compose/reference/up/)

## Resetting your Catapult Server

Did you get your server in a bad state or just want to restart with a fresh chain?  No problem, simlpy stop the running docker service and do the following:

---Reset Steps here---

