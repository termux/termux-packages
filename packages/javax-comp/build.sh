TERMUX_PKG_HOMEPAGE=https://github.com/xatandcatch-blip/javax-comp
TERMUX_PKG_DESCRIPTION="iMYou Engine - Native Multi-Stage Compiler"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="xatandcatch-blip"
TERMUX_PKG_VERSION=3.5.2
TERMUX_PKG_SRCURL=https://github.com/xatandcatch-blip/javax-comp/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make_install() {
	$CXX $CXXFLAGS $CPPFLAGS -std=c++17 \
		$TERMUX_PKG_SRCDIR/javax-comp.cpp \
		$TERMUX_PKG_SRCDIR/xcompiler.cpp \
		-o $TERMUX_PREFIX/bin/javax-comp
		
	chmod 755 $TERMUX_PREFIX/bin/javax-comp
}
