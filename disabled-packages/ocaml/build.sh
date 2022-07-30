TERMUX_PKG_HOMEPAGE=https://ocaml.org
TERMUX_PKG_DESCRIPTION="Programming language supporting functional, imperative and object-oriented styles"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.02.3
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://caml.inria.fr/pub/distrib/ocaml-${TERMUX_PKG_VERSION:0:4}/ocaml-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=83c6697e135b599a196fd7936eaf8a53dd6b8f3155a796d18407b56f91df9ce3
TERMUX_PKG_DEPENDS="pcre, openssl, libuuid"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	./configure -prefix $TERMUX_PREFIX -mandir $TERMUX_PREFIX/share/man/man1 -cc "$CC $CFLAGS $CPPFLAGS $LDFLAGS" \
		-host $TERMUX_HOST_PLATFORM
}
