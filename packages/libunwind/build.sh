TERMUX_PKG_HOMEPAGE=http://www.nongnu.org/libunwind/
TERMUX_PKG_DESCRIPTION="Library to determine the call-chain of a program"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.3.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=43997a3939b6ccdf2f669b50fdb8a4d3205374728c2923ddc2354c65260214f8
TERMUX_PKG_BREAKS="libunwind-dev"
TERMUX_PKG_REPLACES="libunwind-dev"
TERMUX_PKG_SRCURL=https://github.com/libunwind/libunwind/releases/download/v$TERMUX_PKG_VERSION/libunwind-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-tests
--disable-coredump
--disable-minidebuginfo
"

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if [ -n "$TERMUX_ON_DEVICE_BUILD" ]; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi
}

termux_step_post_massage() {
	# Hack to fix problem with building arm c++ code
	# which should not use this libunwind:
	rm $TERMUX_PREFIX/lib/libunwind*
	rm $TERMUX_PREFIX/include/{unwind.h,libunwind*.h}
}
