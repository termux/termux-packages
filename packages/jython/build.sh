TERMUX_PKG_HOMEPAGE=https://www.jython.org/
TERMUX_PKG_DESCRIPTION="Python for the Java Platform"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.7.2
TERMUX_PKG_SRCURL=https://github.com/jython/jython/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d2facdf353ba2f4f4be2ffaa5a493b0fd07c8c927d48feeb2351808ed71188bc
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
