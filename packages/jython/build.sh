TERMUX_PKG_HOMEPAGE=https://www.jython.org/
TERMUX_PKG_DESCRIPTION="Python for the Java Platform"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.7.3
TERMUX_PKG_SRCURL=https://github.com/jython/jython/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d037f437bb1c6399c1c1521320f8775a085a99e6bec7f83c6c9e4ef2e40b19e8
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="openjdk-17"
TERMUX_PKG_BUILD_DEPENDS="ant"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_RM_AFTER_INSTALL="
opt/jython/bin/jython_regrtest.bat
opt/jython/bin/jython.exe
opt/jython/bin/jython.py
"

termux_step_make() {
	sh $TERMUX_PREFIX/bin/ant
}

termux_step_make_install() {
	rm -rf $TERMUX_PREFIX/opt/jython
	mkdir -p $TERMUX_PREFIX/opt/jython
	cp -a $TERMUX_PKG_SRCDIR/dist/* $TERMUX_PREFIX/opt/jython/
	ln -sfr $TERMUX_PREFIX/opt/jython/bin/jython $TERMUX_PREFIX/bin/jython
}
