TERMUX_PKG_HOMEPAGE=https://packages.debian.org/sid/csh
TERMUX_PKG_DESCRIPTION="C Shell with process control from 3BSD."
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20110502-7
TERMUX_PKG_SRCURL=http://deb.debian.org/debian/pool/main/c/csh/csh_20110502.orig.tar.gz
TERMUX_PKG_SHA256=8bcba4fe796df1b9992e2d94e07ce6180abb24b55488384f9954aa61ecd8d68b
TERMUX_PKG_DEPENDS="libbsd, libandroid-glob"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS="${CFLAGS/-Oz/-Os}"
}

termux_step_post_make_install() {
	install -pD ${TERMUX_PKG_BUILDDIR}/csh.1 ${TERMUX_PREFIX}/share/man/man1/csh.1
	gzip -f ${TERMUX_PREFIX}/share/man/man1/csh.1
}
