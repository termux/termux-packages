TERMUX_PKG_HOMEPAGE=https://apt-team.pages.debian.net/python-apt/
TERMUX_PKG_DESCRIPTION="Python bindings for APT"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.7.2"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://ftp.debian.org/debian/pool/main/p/python-apt/python-apt_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=00371ae55d7ebc5fea3b4973f440e0f3683afbe1af7e969706a28c60b47a34d9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="apt, build-essential, libc++, python, texinfo"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"

termux_step_pre_configure() {
	export DEBVER="${TERMUX_PKG_VERSION#*:}"
}
