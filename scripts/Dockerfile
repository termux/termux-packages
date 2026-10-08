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

# Setup Ubuntu host dependencies and builder user:
RUN rm -f /etc/apt/apt.conf.d/docker-clean && \
	echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/99disable-translations && \
	apt-get update && \
	apt-get -yq upgrade && \
	apt-get install -yq --no-install-recommends sudo lsb-release software-properties-common && \
	userdel ubuntu && \
	useradd -u 1001 -U -m -s /bin/bash builder && \
	echo "builder ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/builder && \
	chmod 0440 /etc/sudoers.d/builder && \
	chmod a+rx /tmp/termux-packages/scripts/*.sh /tmp/termux-packages/scripts/build/termux_download.sh && \
	su - builder -c "TERMUX_PKGS__BUILD__IS_DOCKER_BUILD='true' /tmp/termux-packages/scripts/setup-ubuntu.sh" && \
	apt-get remove -yq --autoremove lsb-release software-properties-common && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Setup Android SDK and NDK:
RUN su - builder -c "TERMUX_PKGS__BUILD__IS_DOCKER_BUILD='true' /tmp/termux-packages/scripts/setup-android-sdk.sh" && \
	su - builder -c "rm -f ~/lib/*.zip" && \
	su - builder -c "rm -rf ~/.android/cache/"

USER builder:builder

# We expect this to be mounted with '-v $PWD:/home/builder/termux-packages':
WORKDIR /home/builder/termux-packages
