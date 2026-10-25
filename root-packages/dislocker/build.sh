TERMUX_PKG_HOMEPAGE="https://github.com/Aorimn/dislocker"
TERMUX_PKG_DESCRIPTION="Tool for accessing BitLocker-encrypted volumes"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Infiniti151 <43163551+Infiniti151@users.noreply.github.com>"
TERMUX_PKG_SRCURL="git+https://github.com/Aorimn/dislocker"
TERMUX_PKG_GIT_BRANCH="master"
_COMMIT="0706462db88efe8df88150e4c3e4332b808f4581"
TERMUX_PKG_VERSION="2026.08.31"
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libfuse3, libiconv, mbedtls, ruby"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DRuby_INCLUDE_DIR=$TERMUX_PREFIX/include/ruby-4.0.0
-DRuby_CONFIG_INCLUDE_DIR=$TERMUX_PREFIX/include/ruby-4.0.0/$TERMUX_HOST_PLATFORM
-DRuby_LIBRARY=$TERMUX_PREFIX/lib/libruby.so
-DWITH_RUBY=ON
"

termux_step_post_get_source() {
	git fetch --unshallow || git fetch
	git checkout "$_COMMIT"

	local version="$(git log -1 --format=%cs | sed 's/-/./g')"
	if [ "$version" != "$TERMUX_PKG_VERSION" ]; then
		echo -n "ERROR: The specified version \"$TERMUX_PKG_VERSION\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi
}

termux_step_pre_configure() {
	# Dislocker's CMake configuration expects man pages to be available for
	# the selected target. The source tree does not provide an Android
	# man-page directory, so reuse the existing man pages to satisfy CMake
	# when building for Android.
	mkdir -p "$TERMUX_PKG_SRCDIR/man/android"
	cp "$TERMUX_PKG_SRCDIR/man/linux/"*.1 "$TERMUX_PKG_SRCDIR/man/android/" 2>/dev/null || true
}
