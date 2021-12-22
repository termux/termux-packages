TERMUX_PKG_HOMEPAGE=https://www.gnu.org.ua/software/direvent/
TERMUX_PKG_DESCRIPTION="Monitor of events in file system directories"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/direvent/direvent-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=239822cdda9ecbbbc41a69181b34505b2d3badd4df5367e765a0ceb002883b55
TERMUX_PKG_DEPENDS="libandroid-glob"

termux_step_pre_configure() {
       export LIBS="-landroid-glob"
}
