TERMUX_PKG_HOMEPAGE=https://www.radare.org/
TERMUX_PKG_DESCRIPTION="UNIX-like reverse engineering framework and command-line toolset"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.1.0"
TERMUX_PKG_SRCURL=https://github.com/radareorg/radare2/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=52847eefc0fa9713b8c36e9afe45e0eee0e2d140e4f284c1ad43ae442f76a0a9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libuv"
TERMUX_PKG_BREAKS="radare2-dev"
TERMUX_PKG_REPLACES="radare2-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-compiler=termux-host"

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	# Unset CPPFLAGS to avoid -I$TERMUX_PREFIX/include. This is because
	# radare2 build will put its own -I flags after ours, which causes
	# problems due to name clashes (binutils header files).
	unset CPPFLAGS

	# If this variable is not set, then build will fail on linking with 'pthread'
	export ANDROID=1

	export OBJCOPY=$TERMUX_HOST_PLATFORM-objcopy

	# Remove old libs which may mess with new build:
	rm -f $TERMUX_PREFIX/lib/libr_*
}
