TERMUX_PKG_HOMEPAGE=http://mosh.mit.edu/
TERMUX_PKG_DESCRIPTION="Mobile shell that supports roaming and intelligent local echo"
TERMUX_PKG_VERSION=1.2.5
TERMUX_PKG_SRCURL=https://github.com/ddrown/mosh/archive/android-unicode.zip
TERMUX_PKG_FOLDERNAME="mosh-android-unicode"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-server"
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_DEPENDS="libandroid-support, protobuf, ncurses, openssl, libutil"

termux_step_pre_configure () {
    ./autogen.sh
}

termux_step_post_make_install () {
    cp $TERMUX_PKG_BUILDDIR/src/frontend/mosh $TERMUX_PREFIX/bin/mosh
}

export PROTOC=$TERMUX_TOPDIR/protobuf/host-build/src/protoc

LDFLAGS+=" -lgnustl_shared"
