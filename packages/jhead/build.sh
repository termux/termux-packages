TERMUX_PKG_HOMEPAGE=http://www.sentex.net/~mwandel/jhead/
TERMUX_PKG_DESCRIPTION="Exif Jpeg header manipulation tool"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.04
TERMUX_PKG_SRCURL=http://www.sentex.net/~mwandel/jhead/jhead-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ef89bbcf4f6c25ed88088cf242a47a6aedfff4f08cc7dc205bf3e2c0f10a03c9
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 jhead $TERMUX_PREFIX/bin/jhead
	install -Dm600 jhead.1 $TERMUX_PREFIX/share/man/man1/jhead.1
}
