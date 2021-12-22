TERMUX_PKG_HOMEPAGE=https://github.com/google/gumbo-parser
TERMUX_PKG_DESCRIPTION="An HTML5 parsing library"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.10.1
TERMUX_PKG_SRCURL=https://github.com/google/gumbo-parser/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=28463053d44a5dfbc4b77bcf49c8cee119338ffa636cc17fc3378421d714efad
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	./autogen.sh
}
