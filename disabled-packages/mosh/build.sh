TERMUX_PKG_HOMEPAGE=http://mosh.mit.edu/
TERMUX_PKG_DESCRIPTION="Mobile shell that supports roaming and intelligent local echo"
TERMUX_PKG_VERSION=1.2.5
TERMUX_PKG_SRCURL=http://mosh.mit.edu/mosh-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libandroid-support, protobuf, ncurses, openssl, libutil, perl"

export PROTOC=$TERMUX_TOPDIR/protobuf/host-build/src/protoc

LDFLAGS+=" -lgnustl_shared"
