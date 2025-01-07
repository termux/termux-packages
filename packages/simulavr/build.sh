TERMUX_PKG_HOMEPAGE="https://www.nongnu.org/simulavr"
TERMUX_PKG_DESCRIPTION="Simulator for Microchip AVR (formerly Atmel) microcontrollers"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_VERSION_MAJOR=1
_VERSION_MINOR=1
_VERSION_PATCH=0
TERMUX_PKG_VERSION=1:${_VERSION_MAJOR}.${_VERSION_MINOR}.${_VERSION_PATCH}
TERMUX_PKG_REVISION=1
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

termux_step_post_make_install() {
	mv "$TERMUX_PREFIX/share/doc/common" "$TERMUX_PREFIX/share/doc/simulavr"
	# Headers are moved into their own subdirectory to prevent conflicts.
	# Might cause issues when using them.
	mv "$TERMUX_PREFIX/include" "$TERMUX_PREFIX/include-simulavr"
	mkdir "$TERMUX_PREFIX/include"
	mv "$TERMUX_PREFIX/include-simulavr" "$TERMUX_PREFIX/include/simulavr"
}
