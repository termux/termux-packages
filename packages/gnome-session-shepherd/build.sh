TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/noe/gnome-session-shepherd
TERMUX_PKG_DESCRIPTION="GNOME session manager using GNU Shepherd"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION=1.1
TERMUX_PKG_SRCURL=https://codeberg.org/Baleine/gnome-session-shepherd/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=013f907e5eb6c42ea4138b4f95718bb96d9b97861729fb2425e5b232f34698dc
TERMUX_PKG_DEPENDS="glib, guile, guile-fibers, guile-gi, guile-ini, guile-lib, guile-smc, shepherd"
TERMUX_PKG_BUILD_IN_SRC=false
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dsystem_tests=disabled
-Dunit_tests=disabled
-Ddocs=disabled
-Dshepherd_path=$TERMUX_PREFIX/bin/shepherd
-Dguile_load_path=$TERMUX_PKG_HOSTBUILD_DIR:$TERMUX_PKG_HOSTBUILD_DIR/override:$TERMUX_PKG_HOSTBUILD_DIR/guile-gi/module:$TERMUX_PKG_HOSTBUILD_DIR/guile-ini/modules:$TERMUX_PKG_HOSTBUILD_DIR/guile-smc/modules:$TERMUX_PKG_HOSTBUILD_DIR/guile-lib/src:$TERMUX_PREFIX/share/guile/site/3.0
-Dguile_load_compiled_path=$TERMUX_PKG_HOSTBUILD_DIR/override:$TERMUX_PKG_HOSTBUILD_DIR:$TERMUX_PKG_HOSTBUILD_DIR/guile-gi/module:$TERMUX_PKG_HOSTBUILD_DIR/guile-ini/modules:$TERMUX_PKG_HOSTBUILD_DIR/guile-smc/modules:$TERMUX_PKG_HOSTBUILD_DIR/guile-lib/src
"

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" = "true" ]]; then
		return
	fi
	local _FIBERS_RECIPE="$TERMUX_SCRIPTDIR/packages/guile-fibers/build.sh"
	local _FIBERS_VERSION=$(sed -n 's/^TERMUX_PKG_VERSION=//p' "$_FIBERS_RECIPE")
	local _FIBERS_SHA256=$(sed -n 's/^TERMUX_PKG_SHA256=//p' "$_FIBERS_RECIPE")
	local _FIBERS_TAR="$TERMUX_PKG_TMPDIR/fibers-${_FIBERS_VERSION}.tar.gz"
	termux_download "https://github.com/wingo/fibers/releases/download/v${_FIBERS_VERSION}/fibers-${_FIBERS_VERSION}.tar.gz" "$_FIBERS_TAR" "$_FIBERS_SHA256"
	rm -rf "$TERMUX_PKG_HOSTBUILD_DIR"
	mkdir -p "$TERMUX_PKG_HOSTBUILD_DIR"
	tar xzf "$_FIBERS_TAR" -C "$TERMUX_PKG_HOSTBUILD_DIR" --strip-components=1
	(
		cd "$TERMUX_PKG_HOSTBUILD_DIR"
		./configure --prefix="$TERMUX_PKG_HOSTBUILD_DIR/host-prefix"
		make -j "$TERMUX_PKG_MAKE_PROCESSES"
	)
	local _GI_RECIPE="$TERMUX_SCRIPTDIR/packages/guile-gi/build.sh"
	local _GI_VERSION=$(sed -n 's/^TERMUX_PKG_VERSION=//p' "$_GI_RECIPE")
	local _GI_SHA256=$(sed -n 's/^TERMUX_PKG_SHA256=//p' "$_GI_RECIPE")
	local _GI_TAR="$TERMUX_PKG_TMPDIR/guile-gi-${_GI_VERSION}.tar.gz"
	termux_download "https://github.com/spk121/guile-gi/releases/download/v${_GI_VERSION}/guile_gi-${_GI_VERSION}.tar.gz" "$_GI_TAR" "$_GI_SHA256"
	mkdir -p "$TERMUX_PKG_HOSTBUILD_DIR/guile-gi"
	tar xzf "$_GI_TAR" -C "$TERMUX_PKG_HOSTBUILD_DIR/guile-gi" --strip-components=1
	for _GI_PATCH in "$TERMUX_SCRIPTDIR"/packages/guile-gi/*.patch; do
		sed "s%@TERMUX_PREFIX@%${TERMUX_PREFIX}%g" "$_GI_PATCH" | patch --silent -p1 -d "$TERMUX_PKG_HOSTBUILD_DIR/guile-gi"
	done
	(
		cd "$TERMUX_PKG_HOSTBUILD_DIR/guile-gi"
		./configure --prefix="$TERMUX_PKG_HOSTBUILD_DIR/host-prefix"
		make -j "$TERMUX_PKG_MAKE_PROCESSES"
	)
	local _INI_RECIPE="$TERMUX_SCRIPTDIR/packages/guile-ini/build.sh"
	local _INI_VERSION=$(sed -n 's/^TERMUX_PKG_VERSION=//p' "$_INI_RECIPE")
	local _INI_SHA256=$(sed -n 's/^TERMUX_PKG_SHA256=//p' "$_INI_RECIPE")
	local _INI_TAR="$TERMUX_PKG_TMPDIR/guile-ini-${_INI_VERSION}.tar.gz"
	termux_download "https://github.com/artyom-poptsov/guile-ini/releases/download/v${_INI_VERSION}/guile-ini-${_INI_VERSION}.tar.gz" "$_INI_TAR" "$_INI_SHA256"
	mkdir -p "$TERMUX_PKG_HOSTBUILD_DIR/guile-ini"
	tar xzf "$_INI_TAR" -C "$TERMUX_PKG_HOSTBUILD_DIR/guile-ini" --strip-components=1
	local _SMC_RECIPE="$TERMUX_SCRIPTDIR/packages/guile-smc/build.sh"
	local _SMC_VERSION=$(sed -n 's/^TERMUX_PKG_VERSION=//p' "$_SMC_RECIPE")
	local _SMC_SHA256=$(sed -n 's/^TERMUX_PKG_SHA256=//p' "$_SMC_RECIPE")
	local _SMC_TAR="$TERMUX_PKG_TMPDIR/guile-smc-${_SMC_VERSION}.tar.gz"
	termux_download "https://github.com/artyom-poptsov/guile-smc/releases/download/v${_SMC_VERSION}/guile-smc-${_SMC_VERSION}.tar.gz" "$_SMC_TAR" "$_SMC_SHA256"
	mkdir -p "$TERMUX_PKG_HOSTBUILD_DIR/guile-smc"
	tar xzf "$_SMC_TAR" -C "$TERMUX_PKG_HOSTBUILD_DIR/guile-smc" --strip-components=1
	local _LIB_RECIPE="$TERMUX_SCRIPTDIR/packages/guile-lib/build.sh"
	local _LIB_VERSION=$(sed -n 's/^TERMUX_PKG_VERSION=//p' "$_LIB_RECIPE")
	local _LIB_SHA256=$(sed -n 's/^TERMUX_PKG_SHA256=//p' "$_LIB_RECIPE")
	local _LIB_TAR="$TERMUX_PKG_TMPDIR/guile-lib-${_LIB_VERSION}.tar.gz"
	termux_download "https://download.savannah.nongnu.org/releases/guile-lib/guile-lib-${_LIB_VERSION}.tar.gz" "$_LIB_TAR" "$_LIB_SHA256"
	mkdir -p "$TERMUX_PKG_HOSTBUILD_DIR/guile-lib"
	tar xzf "$_LIB_TAR" -C "$TERMUX_PKG_HOSTBUILD_DIR/guile-lib" --strip-components=1
}

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" = "true" ]]; then
		return
	fi
	export GUILE_EXTENSIONS_PATH="$TERMUX_PKG_HOSTBUILD_DIR/.libs:$TERMUX_PKG_HOSTBUILD_DIR/guile-gi/.libs"
	export LTDL_LIBRARY_PATH="$TERMUX_PKG_HOSTBUILD_DIR/.libs:$TERMUX_PKG_HOSTBUILD_DIR/guile-gi/.libs"
	export FIBERS_BUILD_DIR="$TERMUX_PKG_HOSTBUILD_DIR"
}
