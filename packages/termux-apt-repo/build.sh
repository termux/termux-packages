TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-apt-repo
TERMUX_PKG_DESCRIPTION="Script to create Termux apt repositories"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=0.4
TERMUX_PKG_SHA256=54ea18d06d234d18ab8f7b264c4bd045651eb7908fa3850974b6560c7fb34af3
TERMUX_PKG_SRCURL=https://github.com/termux/termux-apt-repo/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes
# binutils for ar:
TERMUX_PKG_DEPENDS="binutils, python, tar"
