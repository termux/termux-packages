TERMUX_PKG_HOMEPAGE=http://www.mega-nerd.com/libsndfile
TERMUX_PKG_DESCRIPTION="Library for reading/writing audio files"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_SRCURL=https://github.com/libsndfile/libsndfile/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=642a876bd61b63f9346628dba5f8a0356a3ad750c7f6f42019d26ce60ba6a15b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libflac, libogg, libopus, libvorbis"
TERMUX_PKG_BREAKS="libsndfile-dev"
TERMUX_PKG_REPLACES="libsndfile-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-sqliter
--disable-alsa
--disable-mpeg
"
TERMUX_PKG_RM_AFTER_INSTALL="bin/ share/man/man1/"

termux_step_post_get_source() {
	rm -f CMakeLists.txt
}

termux_step_pre_configure() {
	autoreconf -fi
}
