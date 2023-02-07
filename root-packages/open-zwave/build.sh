TERMUX_PKG_HOMEPAGE=https://github.com/OpenZWave/open-zwave
TERMUX_PKG_DESCRIPTION="A C++ library to control Z-Wave Networks via a USB Z-Wave Controller"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=3fff11d246a0d558d26110e1db6bd634a1b347c0
_COMMIT_DATE=20221117
TERMUX_PKG_VERSION=1.6-p${_COMMIT_DATE}
TERMUX_PKG_SRCURL=git+https://github.com/OpenZWave/open-zwave
TERMUX_PKG_SHA256=d1077d3cf7fae3b61de5789321561b17a2bae4705d3016273d65785683bfc062
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libc++"
# XXX: libusb is not linked against (unexpectedly?)
TERMUX_PKG_BUILD_DEPENDS="libusb"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local pdate="p$(git log -1 --format=%cs | sed 's/-//g')"
	if [[ "$TERMUX_PKG_VERSION" != *"${pdate}" ]]; then
		echo -n "ERROR: The version string \"$TERMUX_PKG_VERSION\" is"
		echo -n " different from what is expected to be; should end"
		echo " with \"${pdate}\"."
		return 1
	fi

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
	fi
}

termux_step_pre_configure() {
	export pkgconfigdir=$TERMUX_PREFIX/lib/pkgconfig

	CPPFLAGS+=" -Wno-error=inconsistent-missing-override"
}
