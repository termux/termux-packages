TERMUX_PKG_HOMEPAGE=https://github.com/XmacsLabs/mogan
TERMUX_PKG_DESCRIPTION="A structure editor forked from GNU TeXmacs"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.6
TERMUX_PKG_SRCURL=https://github.com/XmacsLabs/mogan/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=23ae08cd3c2af99d952b5ec37253ee639519402784b8766f37b2d223587659ab
TERMUX_PKG_DEPENDS="freetype, ghostscript, libandroid-complex-math, libandroid-execinfo, libandroid-spawn, libc++, libcurl, libiconv, libjpeg-turbo, libpng, libsqlite, mogan-data, qt5-qtbase, qt5-qtsvg, which, zlib"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools"
TERMUX_PKG_ANTI_BUILD_DEPENDS="which"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_xmake

	# xmake tests -ldl wrongly?
	LD="${CXX}"

	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" ]]; then
		install -Dm755 "${TERMUX_PKG_BUILDER_DIR}/qmake.sh" "${TERMUX_PKG_BUILDDIR}/bin/qmake"
		sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" -i "${TERMUX_PKG_BUILDDIR}/bin/qmake"
		export PATH="${TERMUX_PKG_BUILDDIR}/bin:${TERMUX_PREFIX}/opt/qt/cross/bin:${PATH}"
		export QMAKESPEC="${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross"
	fi

	command -v qmake
	qmake -query
}

termux_step_make() {
	local host_platform="${TERMUX_ARCH}-linux-android"
	case "${TERMUX_ARCH}" in
	arm) host_platform="armv7a-linux-androideabi" ;;
	esac

	echo "xrepo update-repo"
	xrepo update-repo

	echo "xmake config"
	xmake config \
		--yes \
		--verbose \
		--diagnosis \
		-m release \
		--sdk="${TERMUX_STANDALONE_TOOLCHAIN}" \
		--cross="${host_platform}-" \
		--cflags="${CFLAGS}" \
		--cxxflags="${CXXFLAGS}" \
		--ldflags="${LDFLAGS}"

	echo "xmake build"
	xmake build \
		--yes \
		--verbose \
		--diagnosis \
		--jobs="${TERMUX_MAKE_PROCESSES}" \
		--all
}

termux_step_make_install() {
	echo "xmake install"
	xmake install \
		--yes \
		--verbose \
		--diagnosis \
		-o "${TERMUX_PREFIX}" \
		mogan_install

	mkdir -p $TERMUX_PREFIX/share/Xmacs/plugins/shell/bin
	ln -sfTr $TERMUX_PREFIX/{libexec,share}/Xmacs/plugins/shell/bin/tm_shell
}
