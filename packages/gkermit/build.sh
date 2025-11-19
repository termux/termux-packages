TERMUX_PKG_HOMEPAGE=http://www.columbia.edu/kermit/gkermit.html
TERMUX_PKG_DESCRIPTION="Simple, Portable, Free File Transfer Software for UNIX"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.01"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.kermitproject.org/ftp/kermit/archives/gku${TERMUX_PKG_VERSION/./}.tar.gz
TERMUX_PKG_SHA256=19f9ac00d7b230d0a841928a25676269363c2925afc23e62704cde516fc1abbd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_MAKE_PROCESSES=1

termux_step_post_get_source() {
	local file filename
	filename=$(basename "$TERMUX_PKG_SRCURL")
	file="$TERMUX_PKG_CACHEDIR/$filename"
	tar xf "$file" -C "$TERMUX_PKG_SRCDIR"
}
