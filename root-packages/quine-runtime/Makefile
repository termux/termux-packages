# TERMUX_PREFIX is environment variable, but if it is not set, then set default value
ifeq ($(TERMUX_PREFIX),)
    TERMUX_PREFIX := /data/data/com.termux/files/usr
endif

# if TERMUX_PKG_SRCDIR doesn't exist use pwd
ifeq ($(TERMUX_PKG_SRCDIR),)
    TERMUX_PKG_SRCDIR := $(shell pwd)
endif

install:
    echo "installing scripts for quineOS to /opt"
    install -Dm 777 ${TERMUX_PKG_SRCDIR}/scripts/docker.sh ${TERMUX_PREFIX}/opt/docker.sh
    install -Dm 777 ${TERMUX_PKG_SRCDIR}/scripts/network.sh ${TERMUX_PREFIX}/opt/network.sh
    install -Dm 777 ${TERMUX_PKG_SRCDIR}/scripts/canbus.sh ${TERMUX_PREFIX}/opt/canbus.sh
    install -Dm 777 ${TERMUX_PKG_SRCDIR}/scripts/build-tini.sh ${TERMUX_PREFIX}/opt/build-tini.sh
    install -Dm 777 ${TERMUX_PKG_SRCDIR}/scripts/find-serial.sh ${TERMUX_PREFIX}/opt/find-serial.sh

    install -Dm 777 ${TERMUX_PKG_SRCDIR}/bashrc ${TERMUX_PREFIX}/etc/bash.bashrc