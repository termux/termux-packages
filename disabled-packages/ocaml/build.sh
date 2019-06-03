TERMUX_PKG_HOMEPAGE=https://ocaml.org
TERMUX_PKG_DESCRIPTION="Programming language supporting functional, imperative and object-oriented styles"
TERMUX_PKG_VERSION=4.02.3
TERMUX_PKG_SRCURL=http://caml.inria.fr/pub/distrib/ocaml-4.02/ocaml-4.02.3.tar.xz
TERMUX_PKG_DEPENDS="pcre, openssl, libuuid"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure() {
	./configure -prefix $TERMUX_PREFIX -mandir $TERMUX_PREFIX/share/man/man1 -cc "$CC $CFLAGS $CPPFLAGS $LDFLAGS" \
		-host $TERMUX_HOST_PLATFORM
}
