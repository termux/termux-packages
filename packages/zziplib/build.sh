TERMUX_PKG_HOMEPAGE=http://zziplib.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Provides read access to zipped files in a zip-archive, using compression based on free algorithms"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.13.72
TERMUX_PKG_SRCURL=https://github.com/gdraheim/zziplib/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=93ef44bf1f1ea24fc66080426a469df82fa631d13ca3b2e4abaeab89538518dc
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DZZIPTEST=off -DZZIPDOCS=off"
TERMUX_PKG_DEPENDS="zlib"

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/lib
	for lib in zzip zzipfseeko zzipmmapped zzipwrap; do
		ln -sf lib${lib}-0.so lib${lib}.so
	done
}
