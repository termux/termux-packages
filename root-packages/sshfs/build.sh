TERMUX_PKG_HOMEPAGE=https://github.com/libfuse/sshfs
TERMUX_PKG_DESCRIPTION="FUSE client based on the SSH File Transfer Protocol"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.7.3
TERMUX_PKG_SRCURL=https://github.com/libfuse/sshfs/archive/refs/tags/sshfs-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=52a1a1e017859dfe72a550e6fef8ad4f8703ce312ae165f74b579fd7344e3a26
TERMUX_PKG_DEPENDS="libfuse3, glib, openssh | dropbear"
