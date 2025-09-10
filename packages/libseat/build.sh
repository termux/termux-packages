TERMUX_PKG_HOMEPAGE=https://sr.ht/~kennylevinsen/seatd/
TERMUX_PKG_DESCRIPTION="Reference implementation of a wayland compositor"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/kennylevinsen/seatd/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=819979c922a0be258aed133d93920bce6a3d3565a60588d6d372ce9db2712cd3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddefaultpath=$TERMUX_PREFIX/var/run/seatd.sock
"
