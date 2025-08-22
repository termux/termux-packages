TERMUX_PKG_HOMEPAGE=https://github.com/termux/libandroid-shmem
TERMUX_PKG_DESCRIPTION="System V shared memory emulation on Android using ashmem"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.6
# TODO: Revert after real release of libandroid-shmem
#TERMUX_PKG_SRCURL=https://github.com/termux/libandroid-shmem/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SRCURL=https://github.com/michalbednarski/libandroid-shmem/archive/cdee4b0686b3c8e10b79f4e96e3dbaeacbeec5a6.tar.gz
TERMUX_PKG_SHA256=c1b8a3263ddd767671dddb0f64b68cb958f35d0431cd0dc1952031fd287a6327
TERMUX_PKG_BREAKS="libandroid-shmem-dev"
TERMUX_PKG_REPLACES="libandroid-shmem-dev"
TERMUX_PKG_BUILD_IN_SRC=true
