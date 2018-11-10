TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-apt-repo
TERMUX_PKG_DESCRIPTION="Script to create Termux apt repositories"
TERMUX_PKG_VERSION=0.3
TERMUX_PKG_SHA256=8b3d7d22cb413ecf8ac3f3b86897a104d11c7d1c95ad8ebc0fbea44add866779
TERMUX_PKG_SRCURL=https://github.com/termux/termux-apt-repo/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes
# binutils for ar:
TERMUX_PKG_DEPENDS="binutils, python, tar"
