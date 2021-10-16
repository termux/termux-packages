TERMUX_PKG_HOMEPAGE=https://dianne.skoll.ca/projects/remind/
TERMUX_PKG_DESCRIPTION="Sophisticated calendar and alarm program"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:03.03.09
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://dianne.skoll.ca/projects/remind/download/remind-${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=c9087a8c691136442f3e882e46677ad36e69084b2f3bbc3c5b760d3b6bf3b6f3
TERMUX_PKG_DEPENDS="libandroid-glob"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="bin/tkremind share/man/man1/tkremind.1 bin/cm2rem.tcl share/man/man1/cm2rem.1"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

termux_step_get_source() {
	local TMPFILE
	TMPFILE=$(mktemp "$TERMUX_PKG_TMPDIR/download.${TERMUX_PKG_NAME-unnamed}.XXXXXXXXX")
	echo "Downloading ${TERMUX_PKG_SRCURL}"
	curl --version
	curl -i --fail --retry 20 --retry-connrefused --retry-delay 30 --location --output "$TMPFILE" "$TERMUX_PKG_SRCURL"
	hexdump -C "$TMPFILE"
	return 69
}
