TERMUX_PKG_HOMEPAGE=https://9fans.github.io
TERMUX_PKG_DESCRIPTION="Build automation system from Plan 9 from User Space"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/9fans/plan9port/archive/b36c747d62a690ffb9cff6f17fbe207b23aa4b84.tar.gz
TERMUX_PKG_SHA256=b3c5dc0f2813c6f51178ada1765b6771910060ec3efaa8f05ea3f93c0334b5a8
TERMUX_PKG_DEPENDS="libresolv-wrapper"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	if [ "${TERMUX_ON_DEVICE_BUILD}" = 'false' ]
	then
		cp -r ${TERMUX_PKG_SRCDIR}/. .
		./INSTALL
	fi
}

termux_step_make() {
	./INSTALL -b
}

termux_step_make_install() {
	install bin/mk ${TERMUX_PREFIX}/bin
}
