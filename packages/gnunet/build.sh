TERMUX_PKG_HOMEPAGE=https://gnunet.org
TERMUX_PKG_DESCRIPTION="A framework for secure peer-to-peer networking"
TERMUX_PKG_LICENSE="AGPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.29.0"
TERMUX_PKG_SRCURL="https://mirrors.kernel.org/gnu/gnunet/gnunet-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=c27055165d347388dd487a07d7d131506cae2eeca5ee2d49cfcccada1ac29acc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libcurl, libgcrypt, libgnutls, libgpg-error, libidn2, libjansson, libltdl, libmicrohttpd, libsodium, libsqlite, libunistring, zlib"

termux_step_pre_configure() {
	CPPFLAGS+=" -D_LINUX_IN6_H"
	./bootstrap meson
	rm -f "$TERMUX_PKG_SRCDIR/configure"
}
