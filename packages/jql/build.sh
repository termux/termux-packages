TERMUX_PKG_HOMEPAGE="https://github.com/yamafaktory/jql"
TERMUX_PKG_DESCRIPTION="A JSON Query Language CLI tool"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="../../LICENSE-APACHE, ../../LICENSE-MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="9.0.4"
TERMUX_PKG_SRCURL=https://github.com/yamafaktory/jql/archive/refs/tags/jql-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ebd9ab1d91f7cb6efd076b55fa6cae4696360f3b7e1cd77b62173c14d6b5e50e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+.\d+.\d+"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust

	TERMUX_PKG_SRCDIR+="/crates/jql"
	TERMUX_PKG_BUILDDIR="$TERMUX_PKG_SRCDIR"

	# ld.lld: error: undefined symbol: __atomic_load
	if [[ "${TERMUX_ARCH}" == "i686" ]]; then
		local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
		export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=$(${CC} -print-libgcc-file-name)"
	fi
}
