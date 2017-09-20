TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-apt-repo
TERMUX_PKG_DESCRIPTION="Script to create Termux apt repositories"
TERMUX_PKG_VERSION=0.2
TERMUX_PKG_SRCURL=https://github.com/termux/termux-apt-repo/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4899903461d4dd14a15b25292d494064d086d37569f366e5edd005f1dd28b1a8
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes
# binutils for ar:
TERMUX_PKG_DEPENDS="binutils, python, tar"
