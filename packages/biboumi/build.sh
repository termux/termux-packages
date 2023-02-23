TERMUX_PKG_HOMEPAGE=https://biboumi.louiz.org/
TERMUX_PKG_DESCRIPTION="An XMPP gateway that connects to IRC servers and translates between the two protocols"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=9.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/louiz/biboumi/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4d5bd5e21252ab4e79c14413afb922d69beba802519c9f38796f6c1372abac41
TERMUX_PKG_DEPENDS="libc++, libexpat, libgcrypt, libiconv, libidn, libsqlite, libuuid"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITHOUT_BOTAN=ON
-DWITHOUT_POSTGRESQL=ON
-DWITHOUT_SYSTEMD=ON
-DWITHOUT_UDNS=ON
"
