TERMUX_PKG_HOMEPAGE=https://github.com/awesomeWM/awesome
TERMUX_PKG_DESCRIPTION="A highly configurable, next generation framework window manager for X"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Latest release version 4.3 does not support Lua 5.4.
_COMMIT=fa805ab465821c54094126b71a92acf2eba17674
TERMUX_PKG_VERSION="2026.03.31"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=git+https://github.com/awesomeWM/awesome
TERMUX_PKG_SHA256=ed61955ed9bdf1d216b881543572c32c83a15f419d9410d5c6b4ed3df3392383
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="dbus, gdk-pixbuf, glib, libcairo, lua54, libx11, libxcb, libxdg-basedir, libxkbcommon, lua-lgi, pango, startup-notification, xcb-util, xcb-util-cursor, xcb-util-keysyms, xcb-util-wm, xcb-util-xrm"
TERMUX_PKG_BUILD_DEPENDS="imagemagick"
TERMUX_PKG_BREAKS="awesome-luajit"
TERMUX_PKG_CONFLICTS="awesome-luajit"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLUA_MATH_LIBRARY=
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
-DLUA_INCLUDE_DIR=$TERMUX_PREFIX/include/lua5.4
-DLUA_LIBRARY=$TERMUX_PREFIX/lib/liblua5.4.so
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

	find "$TERMUX_PKG_SRCDIR" -type f -print0 | \
		xargs -0 sed -i \
		-e "s|/usr/bin/env lua|/usr/bin/env lua5.4|g" \
		-e "s|/usr/bin/lua|/usr/bin/lua5.4|g"
}

_load_ubuntu_packages() {
	local hostbuild_lua_version="5.4"
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

	local hostbuild_lua_version="5.4"

	local -a ubuntu_packages=(
		# imagemagick
		"imagemagick"
		"imagemagick-7-common"
		"imagemagick-7.q16"
		"libfftw3-double3"
		"liblqr-1-0"
		"libmagickcore-7.q16-10"
		"libmagickwand-7.q16-10"
		# gobject-introspection needed to build lua-lgi
		"libgirepository-1.0-dev"
		"liblua$hostbuild_lua_version-0"
		"liblua$hostbuild_lua_version-dev"
		# gobject-introspect needed by lua-lgi
		"libgirepository-1.0-dev"
		# ldoc is needed for generation of manpages, other lua packages below are dependenies of ldoc
		"lua-ldoc"
		"lua-filesystem"
		"lua-penlight"

		# xcb-cursor
		"libxcb-cursor-dev"
		"libxcb-cursor0"
		"libxcb-image0"
		"libxcb-image0-dev"
		"libxcb-render-util0"
		"libxcb-render-util0-dev"
		"libxcb-util1"
		# xcb-randr
		"libxcb-randr0-dev"
		# xcb-xtest
		"libxcb-xtest0-dev"
		"libxcb-xtest0"
		# xcb-cinerama
		"libxcb-xinerama0-dev"
		"libxcb-xinerama0"
		# xcb-shape
		"libxcb-shape0-dev"
		"libxcb-shape0"
		# xcb-util
		"libxcb-util0-dev"
		"libxcb-util-dev"
		"libxcb-util1"
		# xcb-keysyms
		"libxcb-keysyms1-dev"
		"libxcb-keysyms1"
		# xcb-icccm
		"libxcb-icccm4-dev"
		"libxcb-icccm4"
		# xcb-xfixes
		"libxcb-xfixes0-dev"
		"libxcb-xfixes0"
		# xcb-xkb
		"libxcb-xkb-dev"
		"libxcb-xkb1"
		# xkbcommon-x11
		"libxkbcommon-x11-dev"
		"libxkbcommon-x11-0"
		# libstartup-notification-1.0
		"libstartup-notification0-dev"
		"libstartup-notification0"
		# libxdg-basedir
		"libxdg-basedir-dev"
		"libxdg-basedir1"
		# xcb-xrm
		"libxcb-xrm-dev"
		"libxcb-xrm0"
	)

	termux_download_ubuntu_packages "${ubuntu_packages[@]}"

	local HOSTBUILD_ROOTFS="${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages"

	find "${HOSTBUILD_ROOTFS}" -type f -name '*.pc' | \
		xargs -n 1 sed -i -e "s|/usr|${HOSTBUILD_ROOTFS}/usr|g"
	find "${HOSTBUILD_ROOTFS}/usr/lib/x86_64-linux-gnu" -xtype l \
		-exec sh -c "ln -snvf /usr/lib/x86_64-linux-gnu/\$(readlink \$1) \$1" sh {} \;
	ln -sf convert-im7.q16 "${HOSTBUILD_ROOTFS}/usr/bin/convert"
	ln -sf $(command -v "lua$hostbuild_lua_version") "${HOSTBUILD_ROOTFS}/usr/bin/lua-any"

	_load_ubuntu_packages

	termux_setup_cmake
	termux_setup_ninja
	# XXX: termux_setup_meson is not expected to be called in host build
	AR=;CC=;CFLAGS=;CPPFLAGS=;CXX=;CXXFLAGS=;LD=;LDFLAGS=;PKG_CONFIG=;STRIP=
	termux_setup_meson
	unset AR CC CFLAGS CPPFLAGS CXX CXXFLAGS LD LDFLAGS PKG_CONFIG STRIP

	export PKG_CONFIG_PATH="${HOSTBUILD_ROOTFS}/usr/lib/x86_64-linux-gnu/pkgconfig"
	export CFLAGS="-I${HOSTBUILD_ROOTFS}/usr/include/x86_64-linux-gnu"
	CFLAGS+=" -I/usr/include/xcb"
	CFLAGS+=" -I${HOSTBUILD_ROOTFS}/usr/include/gobject-introspection-1.0"

	LUA_LGI="$TERMUX_PKG_HOSTBUILD_DIR/lua-lgi"
	(
		. "$TERMUX_SCRIPTDIR/packages/lua-lgi/build.sh"
		TERMUX_PKG_SRCDIR="$LUA_LGI" termux_step_get_source
		for patch in "$TERMUX_SCRIPTDIR/packages/lua-lgi"/*.patch; do
			patch -p1 -d "$LUA_LGI" < "$patch"
		done
	)
	$TERMUX_MESON setup \
		"$LUA_LGI" \
		"$LUA_LGI/build" \
		--prefix "$HOSTBUILD_ROOTFS/usr" \
		-Dlua-pc=lua"${hostbuild_lua_version//./}" \
		-Dlua-bin=lua"${hostbuild_lua_version}"
	$TERMUX_MESON compile -C "$LUA_LGI/build"
	$TERMUX_MESON install -C "$LUA_LGI/build"

	cmake \
		-G Ninja \
		-S "${TERMUX_PKG_SRCDIR}" \
		-DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
		-DCMAKE_PREFIX_PATH="${HOSTBUILD_ROOTFS}/usr" \
		-DCMAKE_INSTALL_PREFIX="${HOSTBUILD_ROOTFS}/usr" \
		-DLUA_INCLUDE_DIR="${HOSTBUILD_ROOTFS}/usr/include/lua$hostbuild_lua_version" \
		-DLUA_LIBRARY="/usr/lib/x86_64-linux-gnu/liblua$hostbuild_lua_version.so.0" \
		-DLUA_EXECUTABLE=$(command -v "lua$hostbuild_lua_version")
	ninja \
		-j "${TERMUX_PKG_MAKE_PROCESSES}" \
		install
	unset PKG_CONFIG_PATH CFLAGS
}

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		_load_ubuntu_packages
		export PATH="$TERMUX_PKG_HOSTBUILD_DIR:$PATH"
	fi

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLUA_EXECUTABLE=$(command -v lua5.4)"
}
