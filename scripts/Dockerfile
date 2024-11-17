# Build with:
#	docker build -t ghcr.io/termux/package-builder .
# Push to GitHub registry with:
#	docker push ghcr.io/termux/package-builder
# This is done after changing this file or any of the
# scripts/setup-{ubuntu,android-sdk,cgct}.sh setup scripts.
FROM ubuntu:24.04

# Fix locale to avoid warnings:
ENV LANG=en_US.UTF-8

# Needed for setup:
COPY ./llvm-snapshot.gpg.key ./properties.sh ./setup-android-sdk.sh ./setup-cgct.sh ./setup-ubuntu.sh ./setup-ccache.sh /tmp/
RUN mkdir /tmp/build
COPY ./build/termux_download.sh /tmp/build/

# Setup needed packages and the Android SDK and NDK and the CGCT:
RUN apt-get update && \
	apt-get -yq upgrade && \
	apt-get install -yq sudo lsb-release software-properties-common && \
	userdel ubuntu && \
	useradd -u 1001 -U -m -s /bin/bash builder && \
	echo "builder ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/builder && \
	chmod 0440 /etc/sudoers.d/builder && \
	chmod a+rx /tmp/*.sh /tmp/build/termux_download.sh && \
	su - builder -c /tmp/setup-ubuntu.sh && \
	su - builder -c /tmp/setup-ccache.sh && \
	su - builder -c /tmp/setup-android-sdk.sh && \
	# Removed unused parts to make a smaller Docker image:
	apt-get remove -yq --autoremove lsb-release software-properties-common && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Switch User
USER builder:builder

RUN mkdir -p /home/builder/.config/ccache
RUN echo 'max_size = 0' >> /home/builder/.config/ccache/ccache.conf
RUN echo 'compression = false' >> /home/builder/.config/ccache/ccache.conf
RUN echo 'debug = true' >> /home/builder/.config/ccache/ccache.conf
RUN echo 'debug_dir = /home/builder/termux-packages/ccache-debug/' >> /home/builder/.config/ccache/ccache.conf

# We expect this to be mounted with '-v $PWD:/home/builder/termux-packages':
WORKDIR /home/builder/termux-packages
