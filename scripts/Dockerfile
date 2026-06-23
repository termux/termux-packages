# Build with:
#	docker build -t ghcr.io/termux/package-builder .
# Push to GitHub registry with:
#	docker push ghcr.io/termux/package-builder
# This is done after changing this file or any of the
# scripts/setup-{ubuntu,android-sdk,cgct}.sh setup scripts.
FROM ubuntu:26.04

# Fix locale to avoid warnings:
ENV LANG=en_US.UTF-8

# Needed for setup:
RUN rm -rf /tmp/termux-packages
RUN mkdir -p /tmp/termux-packages
RUN mkdir -p /tmp/termux-packages/scripts
COPY ./llvm-snapshot.gpg.key ./properties.sh ./setup-android-sdk.sh ./setup-cgct.sh ./setup-ubuntu.sh /tmp/termux-packages/scripts/
RUN mkdir -p /tmp/termux-packages/scripts/build
COPY ./build/termux_download.sh /tmp/termux-packages/scripts/build/

# Setup needed packages and the Android SDK and NDK and the CGCT:
RUN apt-get update && \
	apt-get -yq upgrade && \
	apt-get install -yq sudo lsb-release software-properties-common && \
	userdel ubuntu && \
	useradd -u 1001 -U -m -s /bin/bash builder && \
	echo "builder ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/builder && \
	chmod 0440 /etc/sudoers.d/builder && \
	chmod a+rx /tmp/termux-packages/scripts/*.sh /tmp/termux-packages/scripts/build/termux_download.sh && \
	su - builder -c "TERMUX_PKGS__BUILD__IS_DOCKER_BUILD='true' /tmp/termux-packages/scripts/setup-ubuntu.sh" && \
	su - builder -c "TERMUX_PKGS__BUILD__IS_DOCKER_BUILD='true' /tmp/termux-packages/scripts/setup-android-sdk.sh" && \
	# Removed unused parts to make a smaller Docker image:
	apt-get remove -yq --autoremove lsb-release software-properties-common && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	su - builder -c "rm ~/lib/*.zip" && \
	su - builder -c "rm -r ~/.android/cache/" && \
	# Use GNU Coreutils as Rust coreutils has bugs which we are affected with.
	# This needs to be done at the end because installing the packages we need seems to override this somehow
	# Bisecting the problem seems more trouble than overriding this at the end
	# TODO(@thunder-coding): Look back into this when we move to 28.04 LTS
	# https://documentation.ubuntu.com/release-notes/26.04/summary-for-lts-users/#rust-coreutils
	# Known problems with Rust coreutils:
	# comm: https://github.com/uutils/coreutils/issues/12972
	# Ideally we should be able to do this and be done
	# But Canonical doesn't seem to be competent enough to support this
	# build-essential specifically depends on coreutils-from uutils, so that their builds don't break
	# Seems like distros should know that more than their builds, their users builds matter more
	# $SUDO env DEBIAN_FRONTEND=noninteractive \
	# 	apt-get install -yq --allow-remove-essential coreutils-from-gnu coreutils-from-uutils-
	find /usr/lib/cargo/bin/coreutils/ -type f -exec bash -c 'gnuln -sf /usr/bin/gnu"$(basename {})" /usr/bin/"$(basename {})"' \;

# Switch User
USER builder:builder

# We expect this to be mounted with '-v $PWD:/home/builder/termux-packages':
WORKDIR /home/builder/termux-packages
