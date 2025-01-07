TERMUX_PKG_HOMEPAGE=https://github.com/rcoh/angle-grinder
TERMUX_PKG_DESCRIPTION="Slice and dice logs on the command line"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.19.4"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/rcoh/angle-grinder/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=13ae3912dcc34c2648d8ef57fe8d976cb978c70e6976ead079ea5d7609532172
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# ld: error: undefined symbol: __emutls_get_address
	if [[ "${TERMUX_ARCH}" == "arm" ]]; then
		local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
		export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=$($CC -print-libgcc-file-name)"
	fi
}
