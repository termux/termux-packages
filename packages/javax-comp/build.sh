# iMYou Engine Build Recipe
TERMUX_PKG_HOMEPAGE=https://github.com/xatandcatch-blip/javax-comp
TERMUX_PKG_DESCRIPTION="iMYou Engine - Native Multi-Stage Compiler"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="xatandcatch-blip"
TERMUX_PKG_VERSION=3.5.4
TERMUX_PKG_SRCURL=https://github.com/xatandcatch-blip/javax-comp/archive/v${TERMUX_PKG_VERSION}.tar.gz
# Run 'sha256sum' on your release tarball to get this hash
TERMUX_PKG_SHA256=REPLACE_WITH_ACTUAL_SHA256_HASH
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make_install() {
	# Standard Termux Cross-Compilation call
	$CXX $CXXFLAGS $CPPFLAGS -std=c++17 \
		$TERMUX_PKG_SRCDIR/javax-comp.cpp \
		$TERMUX_PKG_SRCDIR/xcompiler.cpp \
		-o $TERMUX_PREFIX/bin/javax-comp
		
	# Ensure the binary has the correct execution permissions
	chmod 755 $TERMUX_PREFIX/bin/javax-comp
}
