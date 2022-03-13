TERMUX_PKG_HOMEPAGE=https://www.gnu.org.ua/software/direvent/
TERMUX_PKG_DESCRIPTION="Monitor of events in file system directories"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.3
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/direvent/direvent-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9405a8a77da49fe92bbe4af18bf925ff91f6d3374c10b7d700a031bacb94c497
TERMUX_PKG_DEPENDS="libandroid-glob"

termux_step_pre_configure() {
       export LIBS="-landroid-glob"
}
