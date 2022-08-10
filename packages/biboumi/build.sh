TERMUX_PKG_HOMEPAGE=https://biboumi.louiz.org/
TERMUX_PKG_DESCRIPTION="An XMPP gateway that connects to IRC servers and translates between the two protocols"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=9.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://git.louiz.org/biboumi/snapshot/biboumi-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=1eff9a9110830e056e434e4edf3a33de52c6d092a3db4877b5531513627e7ecb
TERMUX_PKG_DEPENDS="libc++, libexpat, libgcrypt, libiconv, libidn, libsqlite, libuuid"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITHOUT_BOTAN=ON
-DWITHOUT_POSTGRESQL=ON
-DWITHOUT_SYSTEMD=ON
-DWITHOUT_UDNS=ON
"
