TERMUX_PKG_HOMEPAGE=https://gnunet.org
TERMUX_PKG_DESCRIPTION="A framework for secure peer-to-peer networking"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.24.3"
TERMUX_PKG_SRCURL=https://ftpmirror.gnu.org/gnu/gnunet/gnunet-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5b06897b0e84489bbb438278ec73e4362442b2e05a63e40023ec1d0cccc6c576
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libcurl, libgcrypt, libgnutls, libgpg-error, libidn2, libjansson, libltdl, libmicrohttpd, libsodium, libsqlite, libunistring, zlib"

termux_step_pre_configure() {
	CPPFLAGS+=" -D_LINUX_IN6_H"
	./bootstrap meson
	rm -f $TERMUX_PKG_SRCDIR/configure
}
