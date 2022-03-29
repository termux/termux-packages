TERMUX_PKG_HOMEPAGE=https://git.zx2c4.com/music-file-organizer/about/
TERMUX_PKG_DESCRIPTION="Organizer of audio files into directories based on metadata tags"
# XXX: No license is specified in the source tarball.
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.3
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://git.zx2c4.com/music-file-organizer/snapshot/music-file-organizer-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=042c33f6db7da8889125359db02054fa1fcbfad339e8841e7e26474bf6aed3ad
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libicu, taglib"
