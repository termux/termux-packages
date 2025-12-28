TERMUX_PKG_HOMEPAGE=https://gnunet.org
TERMUX_PKG_DESCRIPTION="A framework for secure peer-to-peer networking"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.26.2"
TERMUX_PKG_SRCURL=https://ftpmirror.gnu.org/gnu/gnunet/gnunet-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=77b7e370cd84037f5792d812536bc5a1035409e6a34aa068d08c9e81be809389
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libcurl, libgcrypt, libgnutls, libgpg-error, libidn2, libjansson, libltdl, libmicrohttpd, libsodium, libsqlite, libunistring, zlib"

termux_step_pre_configure() {
	CPPFLAGS+=" -D_LINUX_IN6_H"
	./bootstrap meson
	rm -f $TERMUX_PKG_SRCDIR/configure
}
