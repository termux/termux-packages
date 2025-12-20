TERMUX_PKG_HOMEPAGE=https://github.com/awesomeWM/awesome
TERMUX_PKG_DESCRIPTION="A highly configurable, next generation framework window manager for X"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Latest release version 4.3 does not support Lua 5.4.
_COMMIT=f009815cb75139acf4d8ba3c1090bf2844d13f4c
TERMUX_PKG_VERSION=2025.05.17
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

	local hostbuild_lua_version="$(echo 'print(_VERSION)' | lua - | cut -d' ' -f2)"
	local ubuntu_packages

	ubuntu_packages+="lua-lgi,"
	ubuntu_packages+="lua-any,"
	ubuntu_packages+="lua-expat,"
	ubuntu_packages+="lua-filesystem,"
	ubuntu_packages+="lua-ldoc,"
	ubuntu_packages+="lua-penlight,"
	ubuntu_packages+="imagemagick,"
	ubuntu_packages+="imagemagick-6-common,"
	ubuntu_packages+="imagemagick-6.q16,"
	ubuntu_packages+="libaom3 libde265-0,"
	ubuntu_packages+="libdjvulibre-text,"
	ubuntu_packages+="libdjvulibre21,"
	ubuntu_packages+="libfftw3-double3,"
	ubuntu_packages+="libheif-plugin-aomdec,"
	ubuntu_packages+="libheif-plugin-aomenc,"
	ubuntu_packages+="libheif-plugin-libde265,"
	ubuntu_packages+="libheif1,"
	ubuntu_packages+="libjxr-tools,"
	ubuntu_packages+="libjxr0t64,"
	ubuntu_packages+="liblqr-1-0,"
	ubuntu_packages+="libmagickcore-6.q16-7-extra,"
	ubuntu_packages+="libmagickcore-6.q16-7t64,"
	ubuntu_packages+="libmagickwand-6.q16-7t64,"
	ubuntu_packages+="libwmflite-0.2-7,"
	ubuntu_packages+="liblua$hostbuild_lua_version-0,"
	ubuntu_packages+="liblua$hostbuild_lua_version-dev,"
	ubuntu_packages+="libstartup-notification0,"
	ubuntu_packages+="libstartup-notification0-dev,"
	ubuntu_packages+="libx11-xcb-dev,"
	ubuntu_packages+="libxcb-cursor-dev,"
	ubuntu_packages+="libxcb-cursor0,"
	ubuntu_packages+="libxcb-icccm4,"
	ubuntu_packages+="libxcb-icccm4-dev,"
	ubuntu_packages+="libxcb-image0,"
	ubuntu_packages+="libxcb-image0-dev,"
	ubuntu_packages+="libxcb-keysyms1,"
	ubuntu_packages+="libxcb-keysyms1-dev,"
	ubuntu_packages+="libxcb-randr0-dev,"
	ubuntu_packages+="libxcb-render-util0,"
	ubuntu_packages+="libxcb-render-util0-dev,"
	ubuntu_packages+="libxcb-shape0,"
	ubuntu_packages+="libxcb-shape0-dev,"
	ubuntu_packages+="libxcb-util-dev,"
	ubuntu_packages+="libxcb-util0-dev,"
	ubuntu_packages+="libxcb-util1,"
	ubuntu_packages+="libxcb-xinerama0,"
	ubuntu_packages+="libxcb-xinerama0-dev,"
	ubuntu_packages+="libxcb-xkb-dev,"
	ubuntu_packages+="libxcb-xkb1,"
	ubuntu_packages+="libxcb-xrm-dev,"
	ubuntu_packages+="libxcb-xrm0,"
	ubuntu_packages+="libxcb-xtest0,"
	ubuntu_packages+="libxcb-xtest0-dev,"
	ubuntu_packages+="libxdg-basedir-dev,"
	ubuntu_packages+="libxdg-basedir1,"
	ubuntu_packages+="libxkbcommon-x11-0,"
	ubuntu_packages+="libxkbcommon-x11-dev,"
	ubuntu_packages+="libxcb-shape0,"
	ubuntu_packages+="libxcb-shape0-dev,"
	ubuntu_packages+="libxcb-xfixes0-dev,"

	termux_download_ubuntu_packages "$ubuntu_packages"

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
