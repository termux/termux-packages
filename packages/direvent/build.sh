TERMUX_PKG_HOMEPAGE=https://www.gnu.org.ua/software/direvent/
TERMUX_PKG_DESCRIPTION="Monitor of events in file system directories"
TERMUX_PKG_VERSION=5.1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/direvent/direvent-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c461600d24183563a4ea47c2fd806037a43354ea68014646b424ac797a959bdb
TERMUX_PKG_DEPENDS="libandroid-glob"

termux_step_pre_configure() {
	LDFLAGS+=" -llog -landroid-glob"
}
