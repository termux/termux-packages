TERMUX_PKG_HOMEPAGE=http://zziplib.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Provides read access to zipped files in a zip-archive, using compression based on free algorithms"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.13.71
TERMUX_PKG_SRCURL=https://github.com/gdraheim/zziplib/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2ee1e0fbbb78ec7cc46bde5b62857bc51f8d665dd265577cf93584344b8b9de2
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DZZIPTEST=off -DZZIPDOCS=off"
TERMUX_PKG_DEPENDS="zlib"

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/lib
	for lib in zzip zzipfseeko zzipmmapped zzipwrap; do
		ln -sf lib${lib}-0.so lib${lib}.so
	done
}
