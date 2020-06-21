TERMUX_PKG_HOMEPAGE=https://www.bunkus.org/videotools/mkvtoolnix/
TERMUX_PKG_DESCRIPTION="Set of tools to create, edit and inspect Matroska files"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=47.0.0
TERMUX_PKG_SRCURL=https://gitlab.com/mbunkus/mkvtoolnix/-/archive/release-$TERMUX_PKG_VERSION/mkvtoolnix-release-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=51e8ee207603771c531385bff7385d4dcdd102511be00bcabb36c341957c6598
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
