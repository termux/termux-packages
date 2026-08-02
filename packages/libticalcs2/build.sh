TERMUX_PKG_HOMEPAGE="http://lpg.ticalc.org/prj_tilp/"
TERMUX_PKG_DESCRIPTION="Provides libticalcs2 library and headers for TiEmu and TiLP"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="3ls-it <3ls-it@pm.me>"
TERMUX_PKG_VERSION=1.1.9
# No version number in the master tarball; this is the cannonical source
# and contains the source tarballs for all libti*
TERMUX_PKG_SRCURL="https://www.ticalc.org/pub/unix/tilibs.tar.gz"
TERMUX_PKG_SHA256=af7b61b5115e5cdae6dc9396004de8828ce00d64d4428e5077a4bf1629e78e1d
# This codebase dates from 2013 and will not likely change soon
# If it does, the maintainer will manually update
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="glib, libticonv, libticables2, libtifiles2"

termux_step_get_source() {
		mkdir -p "$TERMUX_PKG_SRCDIR"
		# Download and extract libticalcs2 source
		termux_download "${TERMUX_PKG_SRCURL}" "${TERMUX_PKG_CACHEDIR}/tilibs.tar.gz"
		tar xf "$TERMUX_PKG_CACHEDIR"/"tilibs.tar.gz"
		tar xf "$TERMUX_PKG_CACHEDIR"/"tilibs2/libticalcs2-${TERMUX_PKG_VERSION}.tar.bz2" \
				-C "$TERMUX_PKG_SRCDIR" --strip-components=1
}

termux_step_pre_configure() {
		autoreconf -fi
}
