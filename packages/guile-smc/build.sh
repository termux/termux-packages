TERMUX_PKG_HOMEPAGE=https://github.com/artyom-poptsov/guile-smc
TERMUX_PKG_DESCRIPTION="State machine compiler for Guile"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION=0.6.4
TERMUX_PKG_SRCURL=https://github.com/artyom-poptsov/guile-smc/releases/download/v${TERMUX_PKG_VERSION}/guile-smc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=67d4d619fd632708341a75274890d32833cbf658ead285ce5e5e091cae6aeebd
TERMUX_PKG_DEPENDS="guile, guile-lib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" = "true" ]]; then
		return
	fi
	local _LIB_RECIPE="$TERMUX_SCRIPTDIR/packages/guile-lib/build.sh"
	local _LIB_VERSION=$(sed -n 's/^TERMUX_PKG_VERSION=//p' "$_LIB_RECIPE")
	local _LIB_SHA256=$(sed -n 's/^TERMUX_PKG_SHA256=//p' "$_LIB_RECIPE")
	local _LIB_TAR="$TERMUX_PKG_TMPDIR/guile-lib-${_LIB_VERSION}.tar.gz"
	termux_download "https://download.savannah.nongnu.org/releases/guile-lib/guile-lib-${_LIB_VERSION}.tar.gz" "$_LIB_TAR" "$_LIB_SHA256"
	rm -rf "$TERMUX_PKG_HOSTBUILD_DIR"
	mkdir -p "$TERMUX_PKG_HOSTBUILD_DIR/guile-lib"
	tar xzf "$_LIB_TAR" -C "$TERMUX_PKG_HOSTBUILD_DIR/guile-lib" --strip-components=1
}

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" = "true" ]]; then
		return
	fi
	export GUILE_LOAD_PATH="$TERMUX_PKG_HOSTBUILD_DIR/guile-lib/src"
}
