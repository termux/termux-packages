TERMUX_PKG_HOMEPAGE=https://github.com/rcr/rirc
TERMUX_PKG_DESCRIPTION="A terminal IRC client in C"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.1.7"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/rcr/rirc/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b354d9859015809c4e5ef695c84110f96966351687cdb67b246a963e86d7602b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="ca-certificates, mbedtls"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	# Avoid duplicate definition of `struct user` (defined in <sys/user.h>):
	find . -type f -name '*.[ch]' | xargs -n 1 \
		sed -i -E 's/(struct user)($|[^_])/\1_\2/g'
	sed -i 's:CC       = cc::g' $TERMUX_PKG_SRCDIR/Makefile
	sed -i 's:CFLAGS   =:CFLAGS   +=:g' $TERMUX_PKG_SRCDIR/Makefile
	sed -i 's:LDFLAGS  =:LDFLAGS  +=:g' $TERMUX_PKG_SRCDIR/Makefile
	sed -i "s:\$(DESTDIR)\$(PREFIX):${TERMUX_PREFIX}:" $TERMUX_PKG_SRCDIR/Makefile
}

termux_step_pre_configure() {
	CPPFLAGS+=" -DMBEDTLS_ALLOW_PRIVATE_ACCESS"
	CFLAGS+=" $CPPFLAGS"
	LDFLAGS+=" -lmbedtls -lmbedx509 -lmbedcrypto"
}

termux_step_configure() {
	make config.h
}
