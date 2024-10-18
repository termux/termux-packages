TERMUX_PKG_HOMEPAGE=http://www.andre-simon.de/doku/ansifilter/en/ansifilter.php
TERMUX_PKG_DESCRIPTION="Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.21
TERMUX_PKG_SRCURL=git+https://gitlab.com/saalen/ansifilter
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_GIT_BRANCH="$TERMUX_PKG_VERSION"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libc++, boost, qt6-qtbase"
TERMUX_PKG_EXTRA_MAKE_ARGS="
DESTDIR=${TERMUX_PREFIX}
PREFIX=
"

termux_step_pre_configure() {
	rm $TERMUX_PKG_SRCDIR/CMakeLists.txt
}
