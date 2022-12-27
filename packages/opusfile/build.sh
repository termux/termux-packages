TERMUX_PKG_HOMEPAGE=https://www.opus-codec.org/
TERMUX_PKG_DESCRIPTION="A high-level API for decoding and seeking within .opus files"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.12
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/xiph/opusfile/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a20a1dff1cdf0719d1e995112915e9966debf1470ee26bb31b2f510ccf00ef40
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libopus, libogg"
TERMUX_PKG_BREAKS="opusfile-dev"
TERMUX_PKG_REPLACES="opusfile-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-http"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=0

	local a
	for a in LT_CURRENT LT_AGE; do
		local _${a}=$(sed -En 's/^OP_'"${a}"'=([0-9]+).*/\1/p' \
				configure.ac)
	done
	local v=$(( _LT_CURRENT - _LT_AGE ))
	if [ ! "${_LT_CURRENT}" ] || [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	echo "PACKAGE_VERSION=$TERMUX_PKG_VERSION" > package_version
	./autogen.sh
}
