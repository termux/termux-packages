TERMUX_PKG_HOMEPAGE=https://gnunet.org
TERMUX_PKG_DESCRIPTION="A framework for secure peer-to-peer networking"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.28.0"
TERMUX_PKG_SRCURL=https://ftpmirror.gnu.org/gnu/gnunet/gnunet-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9f51cd2d713aa8ed41bc503bccb721959302c2e93df1464f6ce70d664d9c889d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libcurl, libgcrypt, libgnutls, libgpg-error, libidn2, libjansson, libltdl, libmicrohttpd, libsodium, libsqlite, libunistring, zlib"

termux_step_pre_configure() {
	CPPFLAGS+=" -D_LINUX_IN6_H"
	./bootstrap meson
	rm -f $TERMUX_PKG_SRCDIR/configure
}
