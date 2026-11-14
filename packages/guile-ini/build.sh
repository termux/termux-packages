TERMUX_PKG_HOMEPAGE=https://github.com/artyom-poptsov/guile-ini
TERMUX_PKG_DESCRIPTION="Library for working with INI format in Guile"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/artyom-poptsov/guile-ini/releases/download/v${TERMUX_PKG_VERSION}/guile-ini-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9b99e47f93346530a324710a8d10f72564e17a807906a6df600c9c61bbfce475
TERMUX_PKG_DEPENDS="guile, guile-smc"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" = "true" ]]; then
		return
	fi
	local _SMC_RECIPE="$TERMUX_SCRIPTDIR/packages/guile-smc/build.sh"
	local _SMC_VERSION=$(sed -n 's/^TERMUX_PKG_VERSION=//p' "$_SMC_RECIPE")
	local _SMC_SHA256=$(sed -n 's/^TERMUX_PKG_SHA256=//p' "$_SMC_RECIPE")
	local _SMC_TAR="$TERMUX_PKG_TMPDIR/guile-smc-${_SMC_VERSION}.tar.gz"
	termux_download "https://github.com/artyom-poptsov/guile-smc/releases/download/v${_SMC_VERSION}/guile-smc-${_SMC_VERSION}.tar.gz" "$_SMC_TAR" "$_SMC_SHA256"
	rm -rf "$TERMUX_PKG_HOSTBUILD_DIR"
	mkdir -p "$TERMUX_PKG_HOSTBUILD_DIR/guile-smc"
	tar xzf "$_SMC_TAR" -C "$TERMUX_PKG_HOSTBUILD_DIR/guile-smc" --strip-components=1
	for _SMC_PATCH in "$TERMUX_SCRIPTDIR"/packages/guile-smc/*.patch; do
		sed "s%@TERMUX_PREFIX@%${TERMUX_PKG_HOSTBUILD_DIR}/smc-prefix%g" "$_SMC_PATCH" | patch --silent -p1 -d "$TERMUX_PKG_HOSTBUILD_DIR/guile-smc"
	done
	local _LIB_RECIPE="$TERMUX_SCRIPTDIR/packages/guile-lib/build.sh"
	local _LIB_VERSION=$(sed -n 's/^TERMUX_PKG_VERSION=//p' "$_LIB_RECIPE")
	local _LIB_SHA256=$(sed -n 's/^TERMUX_PKG_SHA256=//p' "$_LIB_RECIPE")
	local _LIB_TAR="$TERMUX_PKG_TMPDIR/guile-lib-${_LIB_VERSION}.tar.gz"
	termux_download "https://download.savannah.nongnu.org/releases/guile-lib/guile-lib-${_LIB_VERSION}.tar.gz" "$_LIB_TAR" "$_LIB_SHA256"
	mkdir -p "$TERMUX_PKG_HOSTBUILD_DIR/guile-lib"
	tar xzf "$_LIB_TAR" -C "$TERMUX_PKG_HOSTBUILD_DIR/guile-lib" --strip-components=1
	export GUILE_LOAD_PATH="$TERMUX_PKG_HOSTBUILD_DIR/guile-lib/src"
	(
		cd "$TERMUX_PKG_HOSTBUILD_DIR/guile-smc"
		./configure --prefix="$TERMUX_PKG_HOSTBUILD_DIR/smc-prefix"
		make -j "$TERMUX_PKG_MAKE_PROCESSES"
		make install
	)
}

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" = "true" ]]; then
		return
	fi
	export GUILE_LOAD_PATH="$TERMUX_PKG_HOSTBUILD_DIR/guile-smc/modules:$TERMUX_PKG_HOSTBUILD_DIR/guile-lib/src:$TERMUX_PKG_HOSTBUILD_DIR/smc-prefix/share/guile/site/3.0"
	export GUILE_LOAD_COMPILED_PATH="$TERMUX_PKG_HOSTBUILD_DIR/smc-prefix/lib/guile/3.0/site-ccache"
	export PATH="$TERMUX_PKG_HOSTBUILD_DIR/smc-prefix/bin:$PATH"
}
