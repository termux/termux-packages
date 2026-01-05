TERMUX_PKG_HOMEPAGE=https://sr.ht/~kennylevinsen/seatd/
TERMUX_PKG_DESCRIPTION="Reference implementation of a wayland compositor"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.2"
TERMUX_PKG_SRCURL=https://github.com/kennylevinsen/seatd/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2811654fc87b3b1877f62e69cbf1e761c7072146f127860d9b8fe1ca27607d0e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
# -Dman-pages=disabled prevents
# Exec format error: '/data/data/com.termux/files/usr/bin/scdoc'
# if scdoc package was installed in the same container before cross-compiling
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddefaultpath=$TERMUX_PREFIX/var/run/seatd.sock
-Dman-pages=disabled
"
