TERMUX_PKG_HOMEPAGE=https://github.com/awesomeWM/awesome
TERMUX_PKG_DESCRIPTION="A highly configurable, next generation framework window manager for X"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Latest release version 4.3 does not support Lua 5.4.
_COMMIT=f009815cb75139acf4d8ba3c1090bf2844d13f4c
TERMUX_PKG_VERSION=2025.05.17
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/awesomeWM/awesome
TERMUX_PKG_SHA256=d56f6ab4e9d820504509599279904b17e4bd2b4a37edab1adb43b3ecabd70893
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="dbus, gdk-pixbuf, glib, libcairo, liblua54, libx11, libxcb, libxdg-basedir, libxkbcommon, lua-lgi, pango, startup-notification, xcb-util, xcb-util-cursor, xcb-util-keysyms, xcb-util-wm, xcb-util-xrm"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLUA_MATH_LIBRARY=
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
"
TERMUX_PKG_HOSTBUILD=true

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local version="$(git log -1 --format=%cs | sed 's/-/./g')"
	if [ "$version" != "$TERMUX_PKG_VERSION" ]; then
		echo -n "ERROR: The specified version \"$TERMUX_PKG_VERSION\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
	fi
}

_load_ubuntu_packages() {
	local hostbuild_lua_version="$(echo 'print(_VERSION)' | lua - | cut -d' ' -f2)"
	export HOSTBUILD_ROOTFS="${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages"
	export LD_LIBRARY_PATH="${HOSTBUILD_ROOTFS}/usr/lib/x86_64-linux-gnu"
	LD_LIBRARY_PATH+=":${HOSTBUILD_ROOTFS}/usr/lib"
	export LUA_PATH="${HOSTBUILD_ROOTFS}/usr/share/lua/$hostbuild_lua_version/?.lua;${TERMUX_PKG_SRCDIR}/?.lua"
	export LUA_CPATH="${HOSTBUILD_ROOTFS}/usr/lib/x86_64-linux-gnu/lua/$hostbuild_lua_version/?.so"
	export PATH="${HOSTBUILD_ROOTFS}/usr/bin:$PATH"
	local hostbuild_imagemagick_version="$(convert --version | head -n1 | cut -d' ' -f3 | cut -d'-' -f1)"
	export MAGICK_CODER_MODULE_PATH="${HOSTBUILD_ROOTFS}/usr/lib/x86_64-linux-gnu/ImageMagick-$hostbuild_imagemagick_version/modules-Q16/coders"
}

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	local hostbuild_lua_version
	hostbuild_lua_version="$(echo 'print(_VERSION)' | lua - | cut -d' ' -f2)"

	local -a ubuntu_packages=(
		"imagemagick"
		"imagemagick-6-common"
		"imagemagick-6.q16"
		"libaom3"
		"libde265-0"
		"libdjvulibre-text"
		"libdjvulibre21"
		"libfftw3-double3"
		"libheif-plugin-aomdec"
		"libheif-plugin-aomenc"
		"libheif-plugin-libde265"
		"libheif1"
		"libjxr-tools"
		"libjxr0t64"
		"liblqr-1-0"
		"liblua$hostbuild_lua_version-0"
		"liblua$hostbuild_lua_version-dev"
		"libmagickcore-6.q16-7-extra"
		"libmagickcore-6.q16-7t64"
		"libmagickwand-6.q16-7t64"
		"libstartup-notification0"
		"libstartup-notification0-dev"
		"libwmflite-0.2-7"
		"libx11-xcb-dev"
		"libxcb-cursor-dev"
		"libxcb-cursor0"
		"libxcb-icccm4"
		"libxcb-icccm4-dev"
		"libxcb-image0"
		"libxcb-image0-dev"
		"libxcb-keysyms1"
		"libxcb-keysyms1-dev"
		"libxcb-randr0-dev"
		"libxcb-render-util0"
		"libxcb-render-util0-dev"
		"libxcb-shape0"
		"libxcb-shape0"
		"libxcb-shape0-dev"
		"libxcb-shape0-dev"
		"libxcb-util-dev"
		"libxcb-util0-dev"
		"libxcb-util1"
		"libxcb-xfixes0-dev"
		"libxcb-xinerama0"
		"libxcb-xinerama0-dev"
		"libxcb-xkb-dev"
		"libxcb-xkb1"
		"libxcb-xrm-dev"
		"libxcb-xrm0"
		"libxcb-xtest0"
		"libxcb-xtest0-dev"
		"libxdg-basedir-dev"
		"libxdg-basedir1"
		"libxkbcommon-x11-0"
		"libxkbcommon-x11-dev"
		"lua-any"
		"lua-expat"
		"lua-filesystem"
		"lua-ldoc"
		"lua-lgi"
		"lua-penlight"
	)

	termux_download_ubuntu_packages "${ubuntu_packages[@]}"

	local HOSTBUILD_ROOTFS="${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages"

	find "${HOSTBUILD_ROOTFS}" -type f -name '*.pc' | \
		xargs -n 1 sed -i -e "s|/usr|${HOSTBUILD_ROOTFS}/usr|g"
	find "${HOSTBUILD_ROOTFS}/usr/lib/x86_64-linux-gnu" -xtype l \
		-exec sh -c "ln -snvf /usr/lib/x86_64-linux-gnu/\$(readlink \$1) \$1" sh {} \;
	ln -sf convert-im6.q16 "${HOSTBUILD_ROOTFS}/usr/bin/convert"

	_load_ubuntu_packages

	termux_setup_cmake
	termux_setup_ninja

	export PKG_CONFIG_PATH="${HOSTBUILD_ROOTFS}/usr/lib/x86_64-linux-gnu/pkgconfig"
	export CFLAGS="-I${HOSTBUILD_ROOTFS}/usr/include/x86_64-linux-gnu"
	CFLAGS+=" -I/usr/include/xcb"
	cmake \
		-G Ninja \
		-S ${TERMUX_PKG_SRCDIR} \
		-DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
		-DCMAKE_PREFIX_PATH="${HOSTBUILD_ROOTFS}/usr" \
		-DCMAKE_INSTALL_PREFIX="${HOSTBUILD_ROOTFS}/usr"
	ninja \
		-j ${TERMUX_PKG_MAKE_PROCESSES} \
		install
	unset PKG_CONFIG_PATH CFLAGS
}

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		_load_ubuntu_packages
		export PATH="$TERMUX_PKG_HOSTBUILD_DIR:$PATH"
	fi
}
