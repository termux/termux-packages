TERMUX_PKG_HOMEPAGE=https://mediaarea.net/en/MediaInfo
TERMUX_PKG_DESCRIPTION="ZenLib C++ utility library"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_VERSION=0.4.37
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mediaarea.net/download/source/libzen/${TERMUX_PKG_VERSION}/libzen_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8c4323bd3f1a286a565b634cb00c9877922296679f49ac55b05f7c6e56d77c43
TERMUX_PKG_DEPENDS=libandroid-glob
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-shared --enable-static"

termux_step_pre_configure() {
  TERMUX_PKG_SRCDIR="${TERMUX_PKG_SRCDIR}/Project/GNU/Library"
  TERMUX_PKG_BUILDDIR="${TERMUX_PKG_SRCDIR}"
  cd "${TERMUX_PKG_SRCDIR}" || return
  ./autogen.sh
}

termux_step_post_make_install() {
  ln -sf "${TERMUX_PREFIX}/lib/libzen.so" "${TERMUX_PREFIX}/lib/libzen.so.${TERMUX_PKG_VERSION:0:1}"
  ln -sf "${TERMUX_PREFIX}/lib/libzen.so" "${TERMUX_PREFIX}/lib/libzen.so.${TERMUX_PKG_VERSION}"
}
