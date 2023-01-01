TERMUX_PKG_HOMEPAGE="https://www.nongnu.org/simulavr"
TERMUX_PKG_DESCRIPTION="Simulator for Microchip AVR (formerly Atmel) microcontrollers"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_VERSION_MAJOR=1
_VERSION_MINOR=1
_VERSION_PATCH=0
TERMUX_PKG_VERSION=1:${_VERSION_MAJOR}.${_VERSION_MINOR}.${_VERSION_PATCH}
TERMUX_PKG_SRCURL="git+https://git.savannah.nongnu.org/git/simulavr"
TERMUX_PKG_GIT_BRANCH=release-${TERMUX_PKG_VERSION#*:}
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS='
-DBUILD_TCL=OFF
-DBUILD_PYTHON=OFF
-DBUILD_VERILOG=OFF
-DCHECK_VALGRIND=OFF
'

termux_step_post_get_source() {
	echo "Applying hardcode-version.diff"
	sed \
		-e "s|@VERSION_MAJOR@|${_VERSION_MAJOR}|g" \
		-e "s|@VERSION_MINOR@|${_VERSION_MINOR}|g" \
		-e "s|@VERSION_PATCH@|${_VERSION_PATCH}|g" \
		$TERMUX_PKG_BUILDER_DIR/hardcode-version.diff \
		| patch --silent -p1
}
