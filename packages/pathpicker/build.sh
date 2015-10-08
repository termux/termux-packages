TERMUX_PKG_HOMEPAGE=https://facebook.github.io/PathPicker/
TERMUX_PKG_DESCRIPTION="Facebook PathPicker - a terminal-based file picker"
TERMUX_PKG_VERSION=0.6.2
TERMUX_PKG_SRCURL=https://github.com/facebook/PathPicker/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="bash,python"
TERMUX_PKG_FOLDERNAME="PathPicker-${TERMUX_PKG_VERSION}"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make_install () {
	_PKG_DIR=$TERMUX_PREFIX/share/pathpicker
	rm -Rf $_PKG_DIR
	mkdir -p $_PKG_DIR
	cp -Rf src/ $_PKG_DIR
	cp fpp $_PKG_DIR/fpp
	cd $TERMUX_PREFIX/bin
	ln -f -s ../share/pathpicker/fpp fpp
	chmod +x fpp
}
