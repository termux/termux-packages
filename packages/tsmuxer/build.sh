TERMUX_PKG_HOMEPAGE=https://github.com/justdan96/tsMuxer
TERMUX_PKG_DESCRIPTION="A transport stream muxer for remuxing/muxing elementary streams"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Update both tsmuxer and tsmuxergui to the same version in one PR.
_VERSION_REAL=nightly-2023-01-30-02-16-12
TERMUX_PKG_VERSION=$(cut -d- -f2,3,4 <<< "$_VERSION_REAL" | tr '-' '.')
TERMUX_PKG_SRCURL=https://github.com/justdan96/tsMuxer/archive/refs/tags/${_VERSION_REAL}.tar.gz
TERMUX_PKG_SHA256=e975d7ab9a73448b1c2c1ded311977a6f0dc77398edb720158dbcf213d9cf4df
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="freetype, libc++, zlib"
