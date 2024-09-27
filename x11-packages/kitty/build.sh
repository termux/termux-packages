TERMUX_PKG_HOMEPAGE=https://sw.kovidgoyal.net/kitty/
TERMUX_PKG_DESCRIPTION="Cross-platform, fast, feature-rich, GPU based terminal"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
# When updating the package, also update terminfo for kitty by updating
# ncurses' kitty sources in main repo
TERMUX_PKG_VERSION="0.36.4"
TERMUX_PKG_SRCURL=https://github.com/kovidgoyal/kitty/releases/download/v${TERMUX_PKG_VERSION}/kitty-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=10ebf00a8576bca34ae683866c5be307a35f3c517906d6441923fd740db059bd
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

termux_step_host_build() {
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]]; then return; fi

	# https://github.com/kovidgoyal/kitty/issues/6354

	termux_setup_golang
	termux_setup_ninja

	# XXX: termux_setup_meson is not expected to be called in host build
	AR=;CC=;CFLAGS=;CPPFLAGS=;CXX=;CXXFLAGS=;LD=;LDFLAGS=;PKG_CONFIG=;STRIP=
	termux_setup_meson
	unset AR CC CFLAGS CPPFLAGS CXX CXXFLAGS LD LDFLAGS PKG_CONFIG STRIP

	local xcb_proto_ver=$(. ${TERMUX_SCRIPTDIR}/packages/xcb-proto/build.sh; echo ${TERMUX_PKG_VERSION})
	local xcb_proto_srcurl=$(. ${TERMUX_SCRIPTDIR}/packages/xcb-proto/build.sh; echo ${TERMUX_PKG_SRCURL})
	local xcb_proto_sha256=$(. ${TERMUX_SCRIPTDIR}/packages/xcb-proto/build.sh; echo ${TERMUX_PKG_SHA256})
	local libxcb_ver=$(. ${TERMUX_SCRIPTDIR}/packages/libxcb/build.sh; echo ${TERMUX_PKG_VERSION})
	local libxcb_srcurl=$(. ${TERMUX_SCRIPTDIR}/packages/libxcb/build.sh; echo ${TERMUX_PKG_SRCURL})
	local libxcb_sha256=$(. ${TERMUX_SCRIPTDIR}/packages/libxcb/build.sh; echo ${TERMUX_PKG_SHA256})
	local libxkbcommon_ver=$(. ${TERMUX_SCRIPTDIR}/x11-packages/libxkbcommon/build.sh; echo ${TERMUX_PKG_VERSION})
	local libxkbcommon_srcurl=$(. ${TERMUX_SCRIPTDIR}/x11-packages/libxkbcommon/build.sh; echo ${TERMUX_PKG_SRCURL})
	local libxkbcommon_sha256=$(. ${TERMUX_SCRIPTDIR}/x11-packages/libxkbcommon/build.sh; echo ${TERMUX_PKG_SHA256})
	local libx11_ver=$(. ${TERMUX_SCRIPTDIR}/packages/libx11/build.sh; echo ${TERMUX_PKG_VERSION})
	local libx11_srcurl=$(. ${TERMUX_SCRIPTDIR}/packages/libx11/build.sh; echo ${TERMUX_PKG_SRCURL})
	local libx11_sha256=$(. ${TERMUX_SCRIPTDIR}/packages/libx11/build.sh; echo ${TERMUX_PKG_SHA256})

	termux_download "${xcb_proto_srcurl}" "${TERMUX_PKG_CACHEDIR}/$(basename ${xcb_proto_srcurl})" "${xcb_proto_sha256}"
	termux_download "${libxcb_srcurl}" "${TERMUX_PKG_CACHEDIR}/$(basename ${libxcb_srcurl})" "${libxcb_sha256}"
	termux_download "${libxkbcommon_srcurl}" "${TERMUX_PKG_CACHEDIR}/$(basename ${libxkbcommon_srcurl})" "${libxkbcommon_sha256}"
	termux_download "${libx11_srcurl}" "${TERMUX_PKG_CACHEDIR}/$(basename ${libx11_srcurl})" "${libx11_sha256}"

	tar -xf "${TERMUX_PKG_CACHEDIR}/$(basename "${xcb_proto_srcurl}")"
	tar -xf "${TERMUX_PKG_CACHEDIR}/$(basename "${libxcb_srcurl}")"
	tar -xf "${TERMUX_PKG_CACHEDIR}/$(basename "${libxkbcommon_srcurl}")"
	tar -xf "${TERMUX_PKG_CACHEDIR}/$(basename "${libx11_srcurl}")"

	export PKG_CONFIG_PATH="${TERMUX_PKG_HOSTBUILD_DIR}/lib/pkgconfig"
	PKG_CONFIG_PATH+=":${TERMUX_PKG_HOSTBUILD_DIR}/share/pkgconfig"
	PKG_CONFIG_PATH+=":${TERMUX_PKG_HOSTBUILD_DIR}/lib/x86_64-linux-gnu/pkgconfig"

	pushd "xcb-proto-${xcb_proto_ver}"
	./configure --prefix "${TERMUX_PKG_HOSTBUILD_DIR}"
	make -j "${TERMUX_PKG_MAKE_PROCESSES}" install
	popd
	pushd "libxcb-${libxcb_ver}"
	./configure --prefix "${TERMUX_PKG_HOSTBUILD_DIR}"
	make -j "${TERMUX_PKG_MAKE_PROCESSES}" install
	popd
	pushd "libxkbcommon-xkbcommon-${libxkbcommon_ver}"
	${TERMUX_MESON} \
		${TERMUX_PKG_HOSTBUILD_DIR}/build-xkbcommon . \
		--prefix "${TERMUX_PKG_HOSTBUILD_DIR}" \
		-Denable-bash-completion=false \
		-Denable-wayland=false \
		-Denable-docs=false
	ninja \
		-C ${TERMUX_PKG_HOSTBUILD_DIR}/build-xkbcommon \
		-j "${TERMUX_PKG_MAKE_PROCESSES}" install
	popd
	pushd "libX11-${libx11_ver}"
	./configure --prefix "${TERMUX_PKG_HOSTBUILD_DIR}"
	make -j "${TERMUX_PKG_MAKE_PROCESSES}" install
	popd

	pushd "${TERMUX_PKG_SRCDIR}"
	echo "./dev.sh build" && ./dev.sh build
	python3 setup.py clean --clean-for-cross-compile --verbose
	popd
}

termux_step_pre_configure() {
	mkdir -p "$TERMUX_PKG_SRCDIR"/fonts
	termux_download https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/NerdFontsSymbolsOnly/SymbolsNerdFontMono-Regular.ttf "$TERMUX_PKG_SRCDIR"/fonts/SymbolsNerdFontMono-Regular.ttf SKIP_CHECKSUM

	termux_setup_golang
	CFLAGS+=" $CPPFLAGS"

	sed 's|@TERMUX_PREFIX@|'"${TERMUX_PREFIX}"'|g' \
		${TERMUX_PKG_BUILDER_DIR}/posix-shm.c.in > kitty/posix-shm.c
	cp ${TERMUX_PKG_BUILDER_DIR}/reallocarray.c glfw/
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
	rm -Rf $TERMUX_PKG_HOSTBUILD_DIR
}

termux_step_make_install() {
	cp -rT linux-package $TERMUX_PREFIX
}
