TERMUX_PKG_HOMEPAGE=https://github.com/SimulIDE/SimulIDE
TERMUX_PKG_DESCRIPTION="Electronic Circuit Simulator Community Edition"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=4bf26bc839147551a00938aa2949012681a3e046
TERMUX_PKG_VERSION=2021.11.04
TERMUX_PKG_SRCURL=git+https://github.com/SimulIDE/SimulIDE
TERMUX_PKG_SHA256=253fb33e504d2735f425d2bcefed384c3d090feb413920735dbff0415d27620a
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libc++, libelf, qt5-qtbase, qt5-qtmultimedia, qt5-qtscript, qt5-qtserialport, qt5-qtsvg"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true

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

termux_step_pre_configure() {
	export PATH=$TERMUX_PREFIX/opt/qt/cross/bin:$PATH
}

termux_step_configure() {
	"${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
		-spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross" \
		${TERMUX_PKG_EXTRA_CONFIGURE_ARGS}
}

termux_step_make_install() {
	cp -rT ./release/SimulIDE_* $TERMUX_PREFIX
}
