TERMUX_PKG_HOMEPAGE=https://gnunet.org
TERMUX_PKG_DESCRIPTION="A framework for secure peer-to-peer networking"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.24.1"
TERMUX_PKG_SRCURL=https://ftpmirror.gnu.org/gnu/gnunet/gnunet-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c4f8f9d25d3a00f80709583b87aa8312d01454090b73a413b43ec7ec7c07ba39
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libcurl, libgcrypt, libgnutls, libgpg-error, libidn2, libjansson, libltdl, libmicrohttpd, libsodium, libsqlite, libunistring, zlib"

termux_step_pre_configure() {
	CPPFLAGS+=" -D_LINUX_IN6_H"
	./bootstrap meson
	rm -f $TERMUX_PKG_SRCDIR/configure
}
