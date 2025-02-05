TERMUX_PKG_HOMEPAGE=https://sw.kovidgoyal.net/kitty/
TERMUX_PKG_DESCRIPTION="Cross-platform, fast, feature-rich, GPU based terminal"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.39.1"
TERMUX_PKG_SRCURL=https://github.com/kovidgoyal/kitty/releases/download/v${TERMUX_PKG_VERSION}/kitty-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=4baa2a59de7569b3b34f44ea8536c53d312aa76d1347121a2d6557abfde21325
# fontconfig is dlopen(3)ed:
TERMUX_PKG_DEPENDS="dbus, fontconfig, harfbuzz, libpng, librsync, libx11, libxkbcommon, littlecms, ncurses, opengl, openssl, python, xxhash, zlib"
TERMUX_PKG_BUILD_DEPENDS="libxcursor, libxi, libxinerama, libxrandr, simde, xorgproto"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_RM_AFTER_INSTALL="
share/doc/kitty/html
share/terminfo/x/xterm-kitty
"
TERMUX_PKG_AUTO_UPDATE=true

# shellcheck disable=SC2164
termux_step_host_build() {
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]]; then return; fi

	# https://github.com/kovidgoyal/kitty/issues/6354

	termux_setup_golang
	termux_setup_ninja

	# XXX: termux_setup_meson is not expected to be called in host build
	AR=;CC=;CFLAGS=;CPPFLAGS=;CXX=;CXXFLAGS=;LD=;LDFLAGS=;PKG_CONFIG=;STRIP=
	termux_setup_meson
	unset AR CC CFLAGS CPPFLAGS CXX CXXFLAGS LD LDFLAGS PKG_CONFIG STRIP

	local -A ver=(
		[libx11]="$(. "${TERMUX_SCRIPTDIR}/packages/libx11/build.sh"; echo "${TERMUX_PKG_VERSION}")"
		[libxcb]="$(. "${TERMUX_SCRIPTDIR}/packages/libxcb/build.sh"; echo "${TERMUX_PKG_VERSION}")"
		[xcb_proto]="$(. "${TERMUX_SCRIPTDIR}/packages/xcb-proto/build.sh"; echo "${TERMUX_PKG_VERSION}")"
		[libxkbcommon]="$(. "${TERMUX_SCRIPTDIR}/x11-packages/libxkbcommon/build.sh"; echo "${TERMUX_PKG_VERSION}")"
	)
	local -A srcurl=(
		[libx11]="$(. "${TERMUX_SCRIPTDIR}/packages/libx11/build.sh"; echo "${TERMUX_PKG_SRCURL}")"
		[libxcb]="$(. "${TERMUX_SCRIPTDIR}/packages/libxcb/build.sh"; echo "${TERMUX_PKG_SRCURL}")"
		[xcb_proto]="$(. "${TERMUX_SCRIPTDIR}/packages/xcb-proto/build.sh"; echo "${TERMUX_PKG_SRCURL}")"
		[libxkbcommon]="$(. "${TERMUX_SCRIPTDIR}/x11-packages/libxkbcommon/build.sh"; echo "${TERMUX_PKG_SRCURL}")"
	)
	local -A sha256=(
		[libx11]="$(. "${TERMUX_SCRIPTDIR}/packages/libx11/build.sh"; echo "${TERMUX_PKG_SHA256}")"
		[libxcb]="$(. "${TERMUX_SCRIPTDIR}/packages/libxcb/build.sh"; echo "${TERMUX_PKG_SHA256}")"
		[xcb_proto]="$(. "${TERMUX_SCRIPTDIR}/packages/xcb-proto/build.sh"; echo "${TERMUX_PKG_SHA256}")"
		[libxkbcommon]="$(. "${TERMUX_SCRIPTDIR}/x11-packages/libxkbcommon/build.sh"; echo "${TERMUX_PKG_SHA256}")"
	)

	termux_download "${srcurl[libx11]}" "${TERMUX_PKG_CACHEDIR}/$(basename "${srcurl[libx11]}")" "${sha256[libx11]}"
	termux_download "${srcurl[libxcb]}" "${TERMUX_PKG_CACHEDIR}/$(basename "${srcurl[libxcb]}")" "${sha256[libxcb]}"
	termux_download "${srcurl[xcb_proto]}" "${TERMUX_PKG_CACHEDIR}/$(basename "${srcurl[xcb_proto]}")" "${sha256[xcb_proto]}"
	termux_download "${srcurl[libxkbcommon]}" "${TERMUX_PKG_CACHEDIR}/$(basename "${srcurl[libxkbcommon]}")" "${sha256[libxkbcommon]}"

	tar -xf "${TERMUX_PKG_CACHEDIR}/$(basename "${srcurl[libx11]}")"
	tar -xf "${TERMUX_PKG_CACHEDIR}/$(basename "${srcurl[libxcb]}")"
	tar -xf "${TERMUX_PKG_CACHEDIR}/$(basename "${srcurl[xcb_proto]}")"
	tar -xf "${TERMUX_PKG_CACHEDIR}/$(basename "${srcurl[libxkbcommon]}")"

	export PKG_CONFIG_PATH="${TERMUX_PKG_HOSTBUILD_DIR}/lib/pkgconfig"
	PKG_CONFIG_PATH+=":${TERMUX_PKG_HOSTBUILD_DIR}/share/pkgconfig"
	PKG_CONFIG_PATH+=":${TERMUX_PKG_HOSTBUILD_DIR}/lib/x86_64-linux-gnu/pkgconfig"

	pushd "xcb-proto-${ver[xcb_proto]}" || termux_error_exit "Failed to hostbuild 'xcb_proto'"
	./configure --prefix "${TERMUX_PKG_HOSTBUILD_DIR}"
	make -j "${TERMUX_PKG_MAKE_PROCESSES}" install
	popd
	pushd "libxcb-${ver[libxcb]}" || termux_error_exit "Failed to hostbuild 'libxcb'"
	./configure --prefix "${TERMUX_PKG_HOSTBUILD_DIR}"
	make -j "${TERMUX_PKG_MAKE_PROCESSES}" install
	popd
	pushd "libxkbcommon-xkbcommon-${ver[libxkbcommon]}" || termux_error_exit "Failed to hostbuild 'libxkbcommon'"
	${TERMUX_MESON} \
		"${TERMUX_PKG_HOSTBUILD_DIR}/build-xkbcommon" . \
		--prefix "${TERMUX_PKG_HOSTBUILD_DIR}" \
		-Denable-bash-completion=false \
		-Denable-wayland=false \
		-Denable-docs=false
	ninja \
		-C "${TERMUX_PKG_HOSTBUILD_DIR}/build-xkbcommon" \
		-j "${TERMUX_PKG_MAKE_PROCESSES}" install
	popd
	pushd "libX11-${ver[libx11]}" || termux_error_exit "Failed to hostbuild 'libx11'"
	./configure --prefix "${TERMUX_PKG_HOSTBUILD_DIR}"
	make -j "${TERMUX_PKG_MAKE_PROCESSES}" install
	popd

	pushd "${TERMUX_PKG_SRCDIR}" || termux_error_exit "Failed to run './dev.sh build'"
	echo "./dev.sh build" && ./dev.sh build
	python3 setup.py clean --clean-for-cross-compile --verbose
	popd
}

termux_step_pre_configure() {
	mkdir -p "$TERMUX_PKG_SRCDIR"/fonts
	termux_download \
		"https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/NerdFontsSymbolsOnly/SymbolsNerdFontMono-Regular.ttf" \
		"$TERMUX_PKG_SRCDIR/fonts/SymbolsNerdFontMono-Regular.ttf" \
		SKIP_CHECKSUM

	termux_setup_golang
	CFLAGS+=" $CPPFLAGS"

	sed 's|@TERMUX_PREFIX@|'"${TERMUX_PREFIX}"'|g' \
		"${TERMUX_PKG_BUILDER_DIR}/posix-shm.c.in" > kitty/posix-shm.c
	cp "${TERMUX_PKG_BUILDER_DIR}/reallocarray.c" glfw/
}

termux_step_make() {
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]]; then
		python3 setup.py linux-package \
			--ignore-compiler-warnings \
			--verbose
		return
	fi

	python3 setup.py linux-package \
		--ignore-compiler-warnings \
		--skip-code-generation \
		--verbose

	# Needs a new host build each time it's built:
	rm -Rf "$TERMUX_PKG_HOSTBUILD_DIR"
}

termux_step_make_install() {
	cp -rT linux-package "$TERMUX_PREFIX"
}
