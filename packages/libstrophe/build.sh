TERMUX_PKG_HOMEPAGE=https://strophe.im/libstrophe
TERMUX_PKG_DESCRIPTION="libstrophe is a minimal XMPP library written in C"
TERMUX_PKG_LICENSE="MIT, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.12.2"
TERMUX_PKG_SRCURL=https://github.com/strophe/libstrophe/releases/download/${TERMUX_PKG_VERSION}/libstrophe-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=adedca1cfff6a17095aaa7e27eecff2cd3d608087f55fe1e9395a6ab1a893740
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl, libexpat, c-ares"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-cares"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=0

	local v=$(sed -En 's/^m4_define\(\[v_maj\],\s*\[([0-9]+)\].*/\1/p' \
				configure.ac)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	./bootstrap.sh
}
