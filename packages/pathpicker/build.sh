TERMUX_PKG_HOMEPAGE=https://facebook.github.io/PathPicker/
TERMUX_PKG_DESCRIPTION="Facebook PathPicker - a terminal-based file picker"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=0.7.2
TERMUX_PKG_SRCURL=https://github.com/facebook/PathPicker/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e6376fe627474e3e3109f9f913327098e84887fce67a8d1e7d12835ff04ee620
TERMUX_PKG_DEPENDS="bash,python"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install() {
	_PKG_DIR=$TERMUX_PREFIX/share/pathpicker
	rm -Rf $_PKG_DIR
	mkdir -p $_PKG_DIR
	cp -Rf src/ $_PKG_DIR
	cp fpp $_PKG_DIR/fpp
	cd $TERMUX_PREFIX/bin
	ln -f -s ../share/pathpicker/fpp fpp
	chmod +x fpp
}
