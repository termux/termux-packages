TERMUX_PKG_HOMEPAGE=https://9fans.github.io
TERMUX_PKG_DESCRIPTION="A port of many Plan 9 libraries and programs"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/9fans/plan9port/archive/b36c747d62a690ffb9cff6f17fbe207b23aa4b84.tar.gz
TERMUX_PKG_SHA256=b3c5dc0f2813c6f51178ada1765b6771910060ec3efaa8f05ea3f93c0334b5a8
TERMUX_PKG_DEPENDS="libresolv-wrapper, libx11, freetype"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	if [ "${TERMUX_ON_DEVICE_BUILD}" = 'false' ]
	then
		cp -r ${TERMUX_PKG_SRCDIR}/. .
		./INSTALL < /dev/null > /dev/null 2>&1
	fi
}

termux_step_make() {
	export _P9P_BOOTSTRAP=false
	if [ "${TERMUX_ON_DEVICE_BUILD}" = 'false' ]
	then
		cp ${TERMUX_PKG_HOSTBUILD_DIR}/bin/mk ${TERMUX_PKG_SRCDIR}/bin
		export _P9P_BOOTSTRAP=true
	fi
	./INSTALL -b < /dev/null > /dev/null 2>&1
}

termux_step_make_install() {
	local dir=${TERMUX_PREFIX}/lib/plan9
	cp -r . ${dir}
	rm -f ${TERMUX_PREFIX}/bin/9
	(
		cd ${dir}
		./INSTALL -c < /dev/null > /dev/null 2>&1
	)
	ln -s ../lib/plan9/bin/9 ${TERMUX_PREFIX}/bin/9
}
