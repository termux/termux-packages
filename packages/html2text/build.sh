TERMUX_PKG_HOMEPAGE=http://www.mbayer.de/html2text/
TERMUX_PKG_DESCRIPTION="Utility that converts HTML documents into plain text"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1:1.3.2a
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=http://www.mbayer.de/html2text/downloads/html2text-${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=000b39d5d910b867ff7e087177b470a1e26e2819920dcffd5991c33f6d480392
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CXX="$CXX $LDFLAGS"
	mkdir -p $TERMUX_PREFIX/share/man/man1
}
