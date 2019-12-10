TERMUX_PKG_HOMEPAGE=https://mediaarea.net/en/MediaInfo
TERMUX_PKG_DESCRIPTION="Library for reading information from media files"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_VERSION=19.09
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mediaarea.net/download/source/libmediainfo/${TERMUX_PKG_VERSION}/libmediainfo_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=602131fc1730154ca083c8bec6fe42aa2f1f43b36dbaedf26917e27dd8a38e73
TERMUX_PKG_DEPENDS="libcurl, libzen, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-shared --enable-static --with-libcurl"

termux_step_pre_configure() {
  TERMUX_PKG_SRCDIR="${TERMUX_PKG_SRCDIR}/Project/GNU/Library"
  TERMUX_PKG_BUILDDIR="${TERMUX_PKG_SRCDIR}"
  cd "${TERMUX_PKG_SRCDIR}" || return
  ./autogen.sh
}

termux_step_post_make_install() {
  ln -sf "${TERMUX_PREFIX}/lib/libmediainfo.so" "${TERMUX_PREFIX}/lib/libmediainfo.so.0"
  ln -sf "${TERMUX_PREFIX}/lib/libmediainfo.so" "${TERMUX_PREFIX}/lib/libmediainfo.so.0.0"
}
