TERMUX_PKG_HOMEPAGE=https://github.com/keshavbhatt/olivia
TERMUX_PKG_DESCRIPTION="Elegant music player for LINUX"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=4048134f7df91dc9368147d9aac25f408d6ecb59
TERMUX_PKG_VERSION=2022.10.20
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/keshavbhatt/olivia
TERMUX_PKG_SHA256=71994c6c9821f7bdf3560c308e3b0b1b27799b497f0ca9cf93969fbf998289ea
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="coreutils, libc++, mpv, python, qt5-qtbase, qt5-qtwebkit, socat, taglib, wget"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
PREFIX=$TERMUX_PREFIX
"

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
	TERMUX_PKG_SRCDIR+="/src"
	TERMUX_PKG_BUILDDIR="$TERMUX_PKG_SRCDIR"
}

termux_step_configure() {
	"${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
		-spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross" \
		${TERMUX_PKG_EXTRA_CONFIGURE_ARGS}
}
