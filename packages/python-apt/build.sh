TERMUX_PKG_HOMEPAGE=https://apt-team.pages.debian.net/python-apt/
TERMUX_PKG_DESCRIPTION="Python bindings for APT"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.6.0
TERMUX_PKG_SRCURL=https://ftp.debian.org/debian/pool/main/p/python-apt/python-apt_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=557a705723f8acbb62c8af2989d0258dccb0a71f35e34aca53a9b492dbfbcfdd
TERMUX_PKG_DEPENDS="apt, build-essential, libc++, python, texinfo"
TERMUX_PKG_ANTI_BUILD_DEPENDS="build-essential"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"

termux_step_pre_configure() {
	export DEBVER="${TERMUX_PKG_VERSION#*:}"
}
