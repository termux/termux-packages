TERMUX_PKG_HOMEPAGE=https://www.bunkus.org/videotools/mkvtoolnix/
TERMUX_PKG_DESCRIPTION="Set of tools to create, edit and inspect Matroska files"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="81.0"
TERMUX_PKG_SRCURL=git+https://gitlab.com/mbunkus/mkvtoolnix
TERMUX_PKG_GIT_BRANCH=release-$TERMUX_PKG_VERSION
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+"
TERMUX_PKG_DEPENDS="boost, file, libc++, libebml, libflac, libiconv, libmatroska, libogg, libvorbis, pcre2, zlib, qt5-qtbase"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, qt5-qtbase-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_fmt=no
enable_gui=no
--disable-static
--with-boost-filesystem=boost_filesystem
--with-boost-system=boost_system
--with-boost-date-time=boost_date_time
--with-qmake=${TERMUX_PREFIX}/opt/qt/cross/bin/qmake
"

termux_step_pre_configure() {
	export PKG_CONFIG_LIBDIR="$TERMUX_PKG_CONFIG_LIBDIR"
	./autogen.sh
}

termux_step_make() {
	rake
}

termux_step_make_install() {
	rake install
}
