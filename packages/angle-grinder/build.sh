TERMUX_PKG_HOMEPAGE=https://github.com/rcoh/angle-grinder
TERMUX_PKG_DESCRIPTION="Slice and dice logs on the command line"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.19.1"
TERMUX_PKG_SRCURL="https://github.com/rcoh/angle-grinder/archive/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=d2273df2b2eb9845aedaa5476d7c8a90e01c3a0d33f1b11cd33153c5d3ebf3aa
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
