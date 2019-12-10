TERMUX_PKG_HOMEPAGE=https://mediaarea.net/en/MediaInfo
TERMUX_PKG_DESCRIPTION="Command-line utility for reading information from media files"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_VERSION=19.09
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mediaarea.net/download/source/mediainfo/${TERMUX_PKG_VERSION}/mediainfo_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1db9a8d9416e0d276a209eee784d9865b8b4c71a26873c6b72badacc2a4ee670
TERMUX_PKG_DEPENDS=libmediainfo
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-dll"

termux_step_pre_configure() {
  TERMUX_PKG_SRCDIR="${TERMUX_PKG_SRCDIR}/Project/GNU/CLI"
  TERMUX_PKG_BUILDDIR="${TERMUX_PKG_SRCDIR}"
  cd "${TERMUX_PKG_SRCDIR}" || return
  ./autogen.sh
}
