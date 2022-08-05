TERMUX_PKG_HOMEPAGE="https://www.nongnu.org/simulavr"
TERMUX_PKG_DESCRIPTION="Simulator for Microchip AVR (formerly Atmel) microcontrollers"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_SRCURL="https://git.savannah.nongnu.org/git/simulavr.git"
TERMUX_PKG_GIT_BRANCH="master"
# tag: release-1.1.0
_COMMIT="e6eac877e8eb497e1620adfd48f5bc85099d306f"
TERMUX_PKG_VERSION="2019.12.20"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS='
-DBUILD_TCL=OFF
-DBUILD_PYTHON=OFF
-DBUILD_VERILOG=OFF
-DCHECK_VALGRIND=OFF
'

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local version="$(git log -1 --date=format:"%Y.%m.%d" --format="%ad")"
	if [ "$version" != "$TERMUX_PKG_VERSION" ]; then
		echo -n "ERROR: The specified version \"$TERMUX_PKG_VERSION\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi
}
