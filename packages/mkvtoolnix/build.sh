TERMUX_PKG_HOMEPAGE=https://www.bunkus.org/videotools/mkvtoolnix/
TERMUX_PKG_DESCRIPTION="Set of tools to create, edit and inspect Matroska files"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=43.0.0
TERMUX_PKG_SRCURL=https://gitlab.com/mbunkus/mkvtoolnix/-/archive/release-$TERMUX_PKG_VERSION/mkvtoolnix-release-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=d64b8f78f4702b6bfdf0283baf99888b9558ca70fb56cd68bbcb7201e62c7916
TERMUX_PKG_DEPENDS="boost, file, libflac, libogg, libvorbis, zlib"
TERMUX_PKG_BUILD_DEPENDS="fmt, libebml, libmatroska"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
--with-boost-filesystem=boost_filesystem
--with-boost-system=boost_system
--with-boost-date-time=boost_date_time
"

termux_step_pre_configure() {
	./autogen.sh
}

termux_step_make() {
	rake
}

termux_step_make_install() {
	rake install
}
