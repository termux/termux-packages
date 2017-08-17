TERMUX_PKG_HOMEPAGE=http://www.mega-nerd.com/libsndfile
# Await 1.0.29 for update which includes fix for Android build,
# https://github.com/erikd/libsndfile/issues/295
TERMUX_PKG_VERSION=1.0.27
TERMUX_PKG_SRCURL=http://www.mega-nerd.com/libsndfile/files/libsndfile-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a391952f27f4a92ceb2b4c06493ac107896ed6c76be9a613a4731f076d30fac0
TERMUX_PKG_DEPENDS="libflac, libvorbis"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-sqlite --disable-alsa"
