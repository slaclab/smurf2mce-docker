# Docker image with smurf2mce for the SMuRF project

## Description

This docker image, named **smurf2mce** contains smurf2mce, firmware files (mcs and pyrogue tarball) and default configuration files for stable firmware versions.

It is based on the **smurf2mce-base** docker image.

## Source code

The firmware files are checkout from the SLAC's github repositories https://github.com/slaclab/cryo-det.

The configuration files are checkout from the SMuRF's configuration repository https://github.com/slaclab/smurf_cfg.git.

If needed files are not available on any of the github repositories, then then are added to this repository under the [local_files](local_files) directory.

## Building the image

When a tag is pushed to this github repository, a new Docker image is automatically built and push to its [Dockerhub repository](https://hub.docker.com/r/tidair/smurf2mce) using travis.

The resulting docker image is tagged with the same git tag string (as returned by `git describe --tags --always`).

## How to get the container

To get the docker image, first you will need to install the docker engine in you host OS. Then you can pull a copy by running:

```
docker pull tidair/smurf2mce:<TAG>
```

Where **<TAG>** represents the specific tagged version you want to use.

## Running the container

Each docker image defined which it's entry point. Usually the entry point calls the `start_server.sh` (which comes within the `smurf2mce-base` image) script with some pre-defined arguments. You can however, overwrite any of the arguments and/or adding new one by passing them at the end of the docker run command.

You start the container with a command like this one:

```
docker run -ti --rm \
    -v <local_data_dir>:/data \
    tidair/smurf2mce:<TAG> \
    <server_arguments>
```

Where:
- **local_data_dir**: is a local directory in the host CPU which contains the directories `smurf_data` where the data is going to be written to, and `smurf2mce_config` with the smurf2mce configuration files,
- **TAG**: is the tagged version of the container your want to run,
- **server_arguments**: additional and/or redefined server arguments.