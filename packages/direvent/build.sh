TERMUX_PKG_HOMEPAGE=https://www.gnu.org.ua/software/direvent/
TERMUX_PKG_DESCRIPTION="Monitor of events in file system directories"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.4"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/direvent/direvent-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1dbbc6192aab67e345725148603d570c6a2828380c964215762af91524d795ba
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-glob"

termux_step_pre_configure() {
	export LIBS="-landroid-glob"
}
