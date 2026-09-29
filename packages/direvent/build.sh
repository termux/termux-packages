TERMUX_PKG_HOMEPAGE=https://www.gnu.org.ua/software/direvent/
TERMUX_PKG_DESCRIPTION="Monitor of events in file system directories"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.5"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/direvent/direvent-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0e16c0b4b3e6f7673e9b4f31d81ab01236ad22f83538512f3b2f58f9f96fdcb7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-glob"

termux_step_pre_configure() {
	export LIBS="-landroid-glob"
}
