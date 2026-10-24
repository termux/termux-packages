TERMUX_PKG_HOMEPAGE=https://shepherding.services
TERMUX_PKG_DESCRIPTION="Service manager written in Guile"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION=1.0.9
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/shepherd/shepherd-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e488c585c8418df6e8f476dca81b72910f337c9cd3608fb467de5260004000d6
TERMUX_PKG_DEPENDS="guile, guile-fibers"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

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
}

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" = "true" ]]; then
		return
	fi
	export GUILE_LOAD_PATH="$TERMUX_PKG_HOSTBUILD_DIR:$TERMUX_PKG_HOSTBUILD_DIR/override"
	export GUILE_LOAD_COMPILED_PATH="$TERMUX_PKG_HOSTBUILD_DIR/override:$TERMUX_PKG_HOSTBUILD_DIR"
	export GUILE_EXTENSIONS_PATH="$TERMUX_PKG_HOSTBUILD_DIR/.libs"
	export LTDL_LIBRARY_PATH="$TERMUX_PKG_HOSTBUILD_DIR/.libs"
	export FIBERS_BUILD_DIR="$TERMUX_PKG_HOSTBUILD_DIR"
}

termux_step_post_make_install() {
	sed -i 's|bin/guile-3.0|bin/guile|' "$TERMUX_PREFIX"/bin/{halt,herd,reboot,shepherd,shutdown}
}
