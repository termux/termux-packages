TERMUX_PKG_HOMEPAGE=https://github.com/rcr/rirc
TERMUX_PKG_DESCRIPTION="A terminal IRC client in C"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.1.6
TERMUX_PKG_SRCURL=https://github.com/rcr/rirc/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=95ac4fa4538d42509c5ef763afd6b85882f5b8bc0e45dced7b0cb9916961243e
TERMUX_PKG_DEPENDS="ca-certificates, mbedtls"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	# Avoid duplicate definition of `struct user` (defined in <sys/user.h>):
	find . -type f -name '*.[ch]' | xargs -n 1 \
		sed -i -E 's/(struct user)($|[^_])/\1_\2/g'
}

termux_step_pre_configure() {
	CPPFLAGS+=" -DMBEDTLS_ALLOW_PRIVATE_ACCESS"
	CFLAGS+=" $CPPFLAGS"
	LDFLAGS+=" -lmbedtls -lmbedx509 -lmbedcrypto"
}

termux_step_configure() {
	make config.h
}
