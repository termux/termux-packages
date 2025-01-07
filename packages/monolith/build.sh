TERMUX_PKG_HOMEPAGE="https://github.com/Y2Z/monolith"
TERMUX_PKG_DESCRIPTION="CLI tool for saving complete web pages as a single HTML file"
TERMUX_PKG_LICENSE="CC0-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.8.3"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/Y2Z/monolith/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=51769e6505d5708ac296e5d93e280c9fefa7873452d471c5106aaeb7c3667f9f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="openssl"

termux_step_pre_configure() {
	rm -f Makefile

	# ld: error: undefined symbol: __atomic_is_lock_free
	# ld: error: undefined symbol: __atomic_fetch_or_8
	# ld: error: undefined symbol: __atomic_load
	if [[ "${TERMUX_ARCH}" == "i686" ]]; then
		local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
		export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=$(${CC} -print-libgcc-file-name)"
	fi

	export OPENSSL_NO_VENDOR=1
}
