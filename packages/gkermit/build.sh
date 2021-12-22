TERMUX_PKG_HOMEPAGE=http://www.columbia.edu/kermit/gkermit.html
TERMUX_PKG_DESCRIPTION="Simple, Portable, Free File Transfer Software for UNIX"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.00
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://ftp.nluug.nl/pub/networking/kermit/archives/gku${TERMUX_PKG_VERSION/./}.tar.gz
TERMUX_PKG_SHA256=3dbe63291277c4795255343b48b860777fb0a160163d7e1d30b1ee68585593eb
TERMUX_PKG_DEPENDS="libandroid-support"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_MAKE_PROCESSES=1

termux_step_post_get_source() {
	local file filename
	filename=$(basename "$TERMUX_PKG_SRCURL")
	file="$TERMUX_PKG_CACHEDIR/$filename"
	tar xf "$file" -C "$TERMUX_PKG_SRCDIR"
}
