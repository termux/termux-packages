TERMUX_PKG_HOMEPAGE=https://ziglang.org
TERMUX_PKG_DESCRIPTION="General-purpose programming language and toolchain for maintaining robust, optimal, and reusable software."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@leapofazzam123"
TERMUX_PKG_VERSION=0.8.1
TERMUX_PKG_SRCURL=https://ziglang.org/download/$TERMUX_PKG_VERSION/zig-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=8c428e14a0a89cb7a15a6768424a37442292858cdb695e2eb503fa3c7bf47f1a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="llvm, libllvm"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DZIG_TARGET_TRIPLE=$TERMUX_HOST_PLATFORM
-DZIG_TARGET_MCPU=baseline
"

termux_step_pre_configure() {
	termux_setup_cmake
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
			export ZIG_BIN=${TERMUX_SCRIPTDIR}/build-tools/zig-${ZIG_VERSION}/zig
		else
			export ZIG_BIN=${TERMUX_COMMON_CACHEDIR}/zig-$ZIG_VERSION/zig
		fi
	else
		export ZIG_BIN="zig"
	fi
	export CC="$ZIG_BIN cc -mcpu=baseline"
	export CXX="$ZIG_BIN c++ -mcpu=baseline"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DZIG_EXECUTABLE=$ZIG_BIN"
}
