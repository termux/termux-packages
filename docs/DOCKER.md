# Build Environment Documentation

This document is inteneded to describe how to set up a build environment.

Builds are run on Ubuntu installations.

## Docker

For most people the best way to obtain an environment for building packages is by using Docker. This should work everywhere Docker is supported (replace `/` with `\` if using Windows) and ensures an up to date build environment that is tested by other package builders.

Run the following script to setup a container (from an image created by [scripts/Dockerfile](../scripts/Dockerfile)) suitable for building packages:
```Shell
./scripts/run-docker.sh
```
This source folder is mounted as the `/root/termux-packages` data volume, so changes are kept in sync between the host and the container when trying things out before committing, and built deb files will be available on the host in the `debs/` directory just as when building on the host.

The docker container used for building packages is a Ubuntu installation with necessary packages pre-installed. The default user is a non-root user to avoid problems with package builds modifying the system by mistake, but `sudo` can be used to install additional Ubuntu packages to be used during development.

Build commands can be given to be executed in the docker container directly:
```Shell
./scripts/run-docker.sh ./build-package.sh libandroid-support
```
will launch the docker container, execute the `./build-package.sh libandroid-support` command inside it and afterwards return you to the host prompt, with the newly built deb in `debs/` to try out.

For Windows users, there is also a PowerShell script available to start the docker. Run with (be aware of backslashes and normal slashes):
```PowerShell
.\scripts\run-docker.ps1 ./build-package.sh libandroid-support
```
Note that building packages can take up a lot of space (especially if `build-all.sh` is used to build all packages) and you may need to [increase the base device size](http://www.projectatomic.io/blog/2016/03/daemon_option_basedevicesize/) if running with a storage driver using a small base size of 10 GB.

## Ubuntu PC

If you can't run Docker you can use a Ubuntu 18.10 installation (either by installing a virtual maching guest or on direct hardware) by using the below scripts:

- Run `scripts/setup-ubuntu.sh` to install required packages and setup the `/data/` folder.

- Run `scripts/setup-android-sdk.sh` to install the Android SDK and NDK at `$HOME/lib/android-{sdk,ndk}`.

There is also a [Vagrantfile](../scripts/Vagrantfile) available as a shortcut for setting up an Ubuntu installation with the above steps applied.
