TERMUX_PKG_HOMEPAGE=https://github.com/awesomeWM/awesome
TERMUX_PKG_DESCRIPTION="A highly configurable, next generation framework window manager for X (built with luajit)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=cab3e81dc6071e3c1c4bd15cf8fab91236c7f2bd
TERMUX_PKG_VERSION="2026.01.04"
TERMUX_PKG_SRCURL=git+https://github.com/awesomeWM/awesome
TERMUX_PKG_SHA256=f601c5e937d5e0ac5adfc8cf87692f56d3f08c2baa502d6fafd52e666d6cadde
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="dbus, gdk-pixbuf, glib, libcairo, luajit, libx11, libxcb, libxdg-basedir, libxkbcommon, luajit-lgi, pango, startup-notification, xcb-util, xcb-util-cursor, xcb-util-keysyms, xcb-util-wm, xcb-util-xrm"
TERMUX_PKG_BUILD_DEPENDS="imagemagick"
TERMUX_PKG_BREAKS="awesome"
TERMUX_PKG_CONFLICTS="awesome"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLUA_MATH_LIBRARY=
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
-DLUA_INCLUDE_DIR=$TERMUX_PREFIX/include/luajit-2.1
-DLUA_LIBRARY=$TERMUX_PREFIX/lib/libluajit-5.1.so
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
		-e "s|/usr/bin/env lua|/usr/bin/env luajit|g" \
		-e "s|/usr/bin/lua|/usr/bin/luajit|g"
}

_load_ubuntu_packages() {
	local hostbuild_luajit_version="5.1"
	export HOSTBUILD_ROOTFS="${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages"
	export LD_LIBRARY_PATH="${HOSTBUILD_ROOTFS}/usr/lib/x86_64-linux-gnu"
	LD_LIBRARY_PATH+=":${HOSTBUILD_ROOTFS}/usr/lib"
	export LUA_PATH="${HOSTBUILD_ROOTFS}/usr/share/lua/$hostbuild_luajit_version/?.lua;${TERMUX_PKG_SRCDIR}/?.lua"
	export LUA_CPATH="${HOSTBUILD_ROOTFS}/usr/lib/x86_64-linux-gnu/lua/$hostbuild_luajit_version/?.so"
	export PATH="${HOSTBUILD_ROOTFS}/usr/bin:$PATH"
	local hostbuild_imagemagick_version="$(convert --version | head -n1 | cut -d' ' -f3 | cut -d'-' -f1)"
	export MAGICK_CODER_MODULE_PATH="${HOSTBUILD_ROOTFS}/usr/lib/x86_64-linux-gnu/ImageMagick-$hostbuild_imagemagick_version/modules-Q16/coders"
}

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	local hostbuild_luajit_version="5.1"

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
		"libluajit-$hostbuild_luajit_version-2"
		"libluajit-$hostbuild_luajit_version-dev"
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
		"lua-penlight"
	)

	termux_download_ubuntu_packages "${ubuntu_packages[@]}"

	local HOSTBUILD_ROOTFS="${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages"

	find "${HOSTBUILD_ROOTFS}" -type f -name '*.pc' | \
		xargs -n 1 sed -i -e "s|/usr|${HOSTBUILD_ROOTFS}/usr|g"
	find "${HOSTBUILD_ROOTFS}/usr/lib/x86_64-linux-gnu" -xtype l \
		-exec sh -c "ln -snvf /usr/lib/x86_64-linux-gnu/\$(readlink \$1) \$1" sh {} \;
	ln -sf convert-im6.q16 "${HOSTBUILD_ROOTFS}/usr/bin/convert"
	ln -sf $(command -v luajit) "${HOSTBUILD_ROOTFS}/usr/bin/lua-any"

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

	LUAJIT_LGI="$TERMUX_PKG_HOSTBUILD_DIR/luajit-lgi"
	(. "$TERMUX_SCRIPTDIR/packages/luajit-lgi/build.sh"; TERMUX_PKG_SRCDIR="$LUAJIT_LGI" termux_step_get_source)
	$TERMUX_MESON setup \
		"$LUAJIT_LGI" \
		"$LUAJIT_LGI/build" \
		--prefix "$HOSTBUILD_ROOTFS/usr" \
		-Dlua-pc=luajit \
		-Dlua-bin=luajit
	$TERMUX_MESON compile -C "$LUAJIT_LGI/build"
	$TERMUX_MESON install -C "$LUAJIT_LGI/build"

	cmake \
		-G Ninja \
		-S "${TERMUX_PKG_SRCDIR}" \
		-DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
		-DCMAKE_PREFIX_PATH="${HOSTBUILD_ROOTFS}/usr" \
		-DCMAKE_INSTALL_PREFIX="${HOSTBUILD_ROOTFS}/usr" \
		-DLUA_INCLUDE_DIR="${HOSTBUILD_ROOTFS}/usr/include/luajit-2.1" \
		-DLUA_LIBRARY=/usr/lib/x86_64-linux-gnu/libluajit-5.1.so.2 \
		-DLUA_EXECUTABLE=$(command -v luajit)
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

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLUA_EXECUTABLE=$(command -v luajit)"
}
