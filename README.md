[Japanese README](https://github.com/tech-bureau/catapult-service-bootstrap/blob/master/README.ja.md)


# Catapult Service Bootstrap

This repo contains a set of bootstrap and setup scripts to help developers get going quickly with their own working Catapult Service.  The goal is to make it as easy and quick as possible so as a developer you only have to run this setup and within a minute or so you will have a running server ready to start receiving transactions so you can focus on your development work and not setup or configuring servers.

NOTE: this bootstrap setup is for learning and development purposes, it should not power any production Catapult instances.

We use docker images as our default packaging and distribution mechanism.  These bootstrap scripts will prepare some files on disk and then leverage docker-compose to startup and run the needed set of containers so the server can function correctly.

## Evironment Dependencies

The only dependency that is required is git so you can clone this repository, and docker/docker-compose.  If you do not have the docker tools installed alredy you can get the installation details from the docker community website:

[Docker Install Overview Page](https://docs.docker.com/install/#server)

[Docker Compose Install Overview Page](https://docs.docker.com/compose/install/#install-compose)

## Installation & Startup Instructions

1. `git clone git@github.com:tech-bureau/catapult-service-bootstrap.git`
2. `cd catapult-service-bootstrap`
3. `./cmds/start-all`

If you followed the docker installation instructions correctly, or already had docker/docker-compose installed, you should see docker doing its job downloading the container images for the first time, then going through running the bootstrap setup.  Should things succeed it should start the Catapult Server right up and you should see the live logs start scrolling by in the foreground like so:

```
api-node-0_1_c92ee4d5f310 | 2019-06-28 21:44:32.831640 0x00007f1532ffd700: <debug> (cache::SupplementalDataStorage.cpp@31) wrote last recalculation height 1 total transactions 29 (score = [0, 862399713157609], height = 12)
api-node-0_1_c92ee4d5f310 | 2019-06-28 21:44:32.850597 0x00007f15327fc700: <info> (disruptor::ConsumerDispatcher.cpp@43) completing processing of element 11 (1 blocks (heights 12 - 12) [A729516B] from Remote_Pull), last consumer is 0 elements behind
api-node-broker-0_1_3ce1de9c4431 | 2019-06-28 21:44:32.989139 0x00007f73b5b52700: <debug> (subscribers::BrokerMessageReaders.h@89) preparing to process 2 messages from /data/spool/state_change
api-node-broker-0_1_3ce1de9c4431 | 2019-06-28 21:44:33.027969 0x00007f73b6353700: <debug> (subscribers::BrokerMessageReaders.h@89) preparing to process 1 messages from /data/spool/block_change
peer-node-1_1_7a0a46204c44 | 2019-06-28 21:44:38.925347 0x00007fadd515a700: <debug> (src::NetworkHeightService.cpp@51) network chain height increased from 11 to 12
peer-node-0_1_1c756eb90627 | 2019-06-28 21:44:40.955667 0x00007f8258a8d700: <warning> (src::NetworkPacketWritersService.cpp@45) could not find any peer for detecting chain heights
api-node-0_1_c92ee4d5f310 | 2019-06-28 21:44:43.847331 0x00007f157bfff700: <debug> (src::NetworkHeightService.cpp@51) network chain height increased from 11 to 12
```

You can verify things are running by doing a quick curl request to get block information: `curl localhost:3000/block/1`

To stop the server simply press `Ctrl+c` to kill/stop the foreground docker process.

## Updated Dragon Bootstrap

This setup of the bootstrap tool has been updated to support the latest dragon builds.

The main difference in the bootstrap setup is the organization of the cmds/ folder which has a set of shell scripts for performing various actions.

The previous `./clean-all` and `./clean-data` scripts have been moved to `./cmds/clean-all` and `./cmds/clean-data`

Other changes are there are now docker compose files for all services together, like before, but also individual services such as peer nodes, api database, api node + gateway and the new broker service.

### New Broker Service

The big change in latest dragon build and going forward is the introduction of the broker service.  Previously the api node would use the mongo extension plugin to take data written to the chain and copy it to the mongodb setup.  This make the api node more complex and had implications on api node performance and potential issues with failure scenarios.

Now the api node writes to a "spool" directory that is a shared state location on disk.  As the aspi node writes to the spool/ directory, the broker service will read from the /spool directory and take over persiting the chain information into mongodb for api gateway read calls.

NOTE: broker runs on same node and under same config/directory as the api node

### Recovery Tool

There is another new binary in the build for the catapult-server called the recovery tool.  This tools main job is to be run after an unclean shutdown, or after failure, of a node, particularly the api node.  When either the server.lock or broker.lock file(s) are present it typically means that there was an unclean shutdown or failure.  The recovery tool will look at the files on disk under the spool/ folder, clean up the files and sync the data to mongodb, and if all runs okay it will finally delete the lock files and shutdown.

## Bootstrap Scripts/Commands

With this new setup besides starting an entire network at the same time there is also a set of commands and files to start up pieces of a network.  The following are currently provided:

| Command                       |  Description  |
| ----------------------------- | ------------- |
| ./cmds/setup-network            |   This will create the nemesis block and generate all the config files if they do not already exist on disk |
| ./cmds/start-all                |   Creates config and nemesis if doesnt exist, starts up all services, just like in older versions of bootstrap tool |
| ./cmds/stop-all                 |   Stop all the services |
| ./cmds/start-catapult-peers     |   Start peer0 and peer1 services only |
| ./cmds/stop-catapult-peers      |   Stop peer0 and peer1 services |
| ./cmds/start-api-db             |   Start the mongodb instance and configure schema/indexes if needed |
| ./cmds/stop-api-db              |   Stop the mongdb service |
| ./cmds/start-catapult-api       |   Start the api node and REST gateway services |
| ./cmds/stop-catapult-api        |   Stop the api node and REST gateway services |
| ./cmds/start-catapult-api-broker|   Start just the api broker service |
| ./cmds/stop-catapult-api-broker |   Stop just the api broker service |

All start commands take flags `-b` for forcing a build of docker containers, as well as a `-d` for running container services in a background process.

## Keys Setup

The bootstrap scripts take care of initial key generation and configuration.  After running for the first time you will have a set of public/private key pairs saved to a couple of files.  You can get the details of the key(s) that are being used in your test setup by going to the follwoing directory:

```
ubuntu@catapult:~/catapult$ cd  build/generated-addresses/
ubuntu@catapult:~/catapult/build/generated-addresses$ ls
addresses.yaml  raw-addresses.txt  README.md
```

The file `raw-addresses.txt` is a set of addresses that have been generated fresh as part of the docker-compose run using the Catapult address utility tool.

The file `addresses.yaml` are keys from the `raw-addresses.txt` file but formatted in yaml form and assigned to different roles, such as for the Catapult nodes, the harvestor key(s), etc. This yaml file is used as an input for the Catapult config files generated during the initial run.

NOTE: the keys under the yaml key 'nemesis_addresses', which are the keys that are assigned test xem funds as part of the nemesis block generation.

## Starting as a Background Process

Pass a `-d` flag to any of the start commands

For more detailed usage of the `docker-compose up` command you can check out dockers community docs:

[Docker Compose Up Command Overview](https://docs.docker.com/compose/reference/up/)


## Resetting your Catapult Server

You can start/stop your Catapult Service as you need.  Each time you start it back up it will continue running from where it left off.

If your service is in a bad state, or you just want to restart from fresh again you can do so easily with this bootstrap tool resetting things up for you.  To reset from scratch:

1. Stop the running Catapult Service if its running (use single Ctrl+C if running in the foreground, or navigate to the repo directory and run `./cmds/stop-all` if running in the background)

2. Run one of the provided clean up scripts:

- Executing `./cmds/clean-data` will keep the configuration and generated keys in place, but delete all of the blockchain and cache data. When restarted, Catapult will start fresh

- Executing `./cmds/clean-all` will both clean the data and additionally will remove the generated keys and the configuration generated from these keys. After running this script, new keys found in directory build/generated-addresses/ will have to be used in any app or script you are developing from.

## Known Issues

The Catapult cache and query engine is powered by mongodb.  There are some known issues with the latest storage engine in some docker environments.  The previous temporary fix was to use an older version with a custom docker compose file, that has been removed in the dragon release, please submit an issue if running into it and we can look at resurecting it.

