## TODO: restore fakeroot functionality

TERMUX_PKG_HOMEPAGE=https://github.com/alpinelinux/abuild
TERMUX_PKG_DESCRIPTION="Build script to build Alpine packages"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=3.4.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/alpinelinux/abuild/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f6f704e34f9d388a0228b645050dc7db7bf92f15a088835ae2c9b244420b9b61
TERMUX_PKG_DEPENDS="apk-tools, autoconf, automake, bash, clang, curl, libtool, make, openssl-tool, pkg-config, tar, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="sysconfdir=$TERMUX_PREFIX/etc"
TERMUX_PKG_CONFFILES="etc/abuild.conf"

TERMUX_PKG_RM_AFTER_INSTALL="
bin/abuild-adduser
bin/abuild-addgroup
bin/abuild-apk
bin/abuild-sudo
bin/buildlab
"

termux_step_post_make_install() {
    install -Dm600 "$TERMUX_PKG_SRCDIR/abuild.conf" "$TERMUX_PREFIX/etc/abuild.conf"
}
