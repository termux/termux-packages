TERMUX_PKG_HOMEPAGE=https://github.com/notaz/pcsx_rearmed
TERMUX_PKG_DESCRIPTION="Yet another PCSX fork based on the PCSX-Reloaded project"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26"
TERMUX_PKG_SRCURL=git+https://github.com/notaz/pcsx_rearmed
TERMUX_PKG_GIT_BRANCH=r${TERMUX_PKG_VERSION}
TERMUX_PKG_SHA256=887e9b5ee7b8115d35099c730372b4158fd3e215955a06d68e20928b339646af
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libpng, opengl, pulseaudio, sdl, zlib"
TERMUX_PKG_BUILD_DEPENDS="binutils-cross"
TERMUX_PKG_BUILD_IN_SRC=true

termux_pkg_auto_update() {
	# Get latest release tag:
	local tag="$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL}")"
	if grep -qP "^r\d+\$" <<<"$tag"; then
		termux_pkg_upgrade_version "$tag"
	else
		echo "WARNING: Skipping auto-update: Not a release ($tag)"
	fi
}

termux_step_post_get_source() {
	# convert CRLF to LF globally while working with this package in termux
	# https://github.com/termux/termux-packages/issues/11744
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		DOS2UNIX="$TERMUX_PKG_TMPDIR/dos2unix"
		(. "$TERMUX_SCRIPTDIR/packages/dos2unix/build.sh"; TERMUX_PKG_SRCDIR="$DOS2UNIX" termux_step_get_source)
		pushd "$DOS2UNIX"
		make dos2unix
		popd # DOS2UNIX
		export PATH="$DOS2UNIX:$PATH"
	fi

	find "$TERMUX_PKG_SRCDIR" -type f -print0 | xargs -0 dos2unix
}

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS"
	CFLAGS="${CFLAGS/-Oz/-Os}"
	if [ "$TERMUX_ARCH" = "arm" ]; then
		termux_setup_no_integrated_as
	fi
	export SDL_CONFIG="$TERMUX_PREFIX/bin/sdl-config"
}

termux_step_configure() {
	sh ./configure
}

termux_step_make_install() {
	install -Dm755 pcsx $TERMUX_PREFIX/bin/pcsx
	mkdir -p $TERMUX_PREFIX/etc/pcsx $TERMUX_PREFIX/lib/pcsx_plugins
	cp -fr frontend/pandora/skin $TERMUX_PREFIX/etc/pcsx/
	install -m755 plugins/*.so $TERMUX_PREFIX/lib/pcsx_plugins/
	ln -fs ../../lib/pcsx_plugins $TERMUX_PREFIX/etc/pcsx/plugins
}
