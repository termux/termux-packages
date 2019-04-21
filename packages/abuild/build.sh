TERMUX_PKG_HOMEPAGE=https://github.com/alpinelinux/abuild
TERMUX_PKG_DESCRIPTION="Build script to build Alpine packages"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=3.2.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=45b26674ca416e71612ff7924169a890a2cc45e945ecca33bc382f98e9ec3eb7
TERMUX_PKG_SRCURL=https://github.com/alpinelinux/abuild/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="apk-tools, autoconf, automake, bash, clang, curl, libtool, make, openssl-tool, pkg-config, tar, zlib"
TERMUX_PKG_BUILD_IN_SRC=yes
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
