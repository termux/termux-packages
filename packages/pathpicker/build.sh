TERMUX_PKG_HOMEPAGE=https://facebook.github.io/PathPicker/
TERMUX_PKG_DESCRIPTION="Facebook PathPicker - a terminal-based file picker"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.5
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/facebook/PathPicker/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b0142676ed791085d619d9b3d28d28cab989ffc3b260016766841c70c97c2a52
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="bash,python"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	_PKG_DIR=$TERMUX_PREFIX/share/pathpicker
	rm -Rf $_PKG_DIR src/tests
	mkdir -p $_PKG_DIR
	cp -Rf src/ $_PKG_DIR
	cp fpp $_PKG_DIR/fpp
	cd $TERMUX_PREFIX/bin
	ln -f -s ../share/pathpicker/fpp fpp
	chmod +x fpp
}
