TERMUX_PKG_HOMEPAGE=https://github.com/rcoh/angle-grinder
TERMUX_PKG_DESCRIPTION="Slice and dice logs on the command line"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.19.3"
TERMUX_PKG_SRCURL="https://github.com/rcoh/angle-grinder/archive/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=9c32de7b00e8243f4a36ebb069e5382f80fc8fd0937ff49600541c95e6fdc8f5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# ```
	# ld: error: undefined symbol: __emutls_get_address
	# ```
	# It isn't able to find/link with `libgcc` during arm build.

	if [[ "${TERMUX_ARCH}" == "arm" ]]; then
		RUSTFLAGS+=" -C link-arg=$($CC -print-libgcc-file-name)"
	fi
}
