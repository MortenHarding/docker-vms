# VMS Docker containers

- [This Repo](#this-repo)
  - [The benefit of this Repo](#the-benefit-of-this-repo)
  - [Prerequisites](#Prerequisites)
- [Quick start guide](#Quick-start-guide)
  - [Install the prerequisites](#install-the-prerequisites)
  - [Start both VMS vax and alpha emulator](#start-both-vms-vax-and-alpha-emulator)

# This Repo

The containers that can be provisioned using the code in this repo contain 2 emulators, SimH and axpbox, that can be used to startup OpenVMS on either VAX or Alpha architecture.
The docker containers are setup to download the ISO files for both OpenVMS 7.3 and OpenVMS 8.4, giving you an easy start for building you own OpenVMS installation.
All that is required is Docker.

## The benefit of this Repo 

Using Docker compose and the [compose.yml](https://github.com/MortenHarding/docker-vms/blob/main/compose.yml) file from this repo, 
you can:
 * Start 2 emulators, SimH for vax/vms and axpbox for vms on the Alpha architecture using one command.
 * The emulators will boot from the mounted install ISO for OpenVMS 7.3 and OpenVMS 8.4.
 * You can now access the OpenVMS install command using telnet 


## Prerequisites

* [Docker](https://www.docker.com/get-started)
* [compose.yml](https://github.com/MortenHarding/docker-vms/blob/main/compose.yml). This is the only file required from github repo [docker-vms](https://github.com/MortenHarding/docker-vms)

# Quick start guide

## Install the prerequisites

* Install [Docker](https://www.docker.com/get-started). 
* Download [compose.yml](https://github.com/MortenHarding/docker-vms/blob/main/compose.yml) into an empty directory.

## Start both VMS vax and alpha emulator

* Run the following command from the directory containing [compose.yml](https://github.com/MortenHarding/docker-vms/blob/main/compose.yml).

```sh
docker compose up -d
```

This will pull the container images from [hub.docker.com](https://hub.docker.com/r/mhardingdk/vms) 
and start a container for each of the 2 emulators, SimH and axpbox.

