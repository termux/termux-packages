TERMUX_PKG_HOMEPAGE=https://zziplib.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Provides read access to zipped files in a zip-archive, using compression based on free algorithms"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.13.76"
TERMUX_PKG_SRCURL=https://github.com/gdraheim/zziplib/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=08b0e300126329c928a41b6d68e397379fad02469e34a0855d361929968ea4c0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DZZIPTEST=off -DZZIPDOCS=off"
TERMUX_PKG_DEPENDS="zlib"

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/lib
	for lib in zzip zzipfseeko zzipmmapped zzipwrap; do
		ln -sf lib${lib}-0.so lib${lib}.so
	done
}
