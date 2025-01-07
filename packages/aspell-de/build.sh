TERMUX_PKG_HOMEPAGE=http://aspell.net/
TERMUX_PKG_DESCRIPTION="German dictionary for aspell"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:20161207.7.0"
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/aspell/dict/de/aspell6-de-$(sed 's/\./-/g' <<< ${TERMUX_PKG_VERSION:2}).tar.bz2
TERMUX_PKG_SHA256=c2125d1fafb1d4effbe6c88d4e9127db59da9ed92639c7cbaeae1b7337655571
TERMUX_PKG_DEPENDS="aspell"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_configure() {
	cd ${TERMUX_PKG_SRCDIR}
	sed -i 's#^dictdir=.*#dictdir='${TERMUX_PREFIX}'/lib/aspell-0.60#' configure
	sed -i 's#^datadir=.*#datadir='${TERMUX_PREFIX}'/lib/aspell-0.60#' configure
	./configure
}

termux_step_make() {
	make
}

termux_step_make_install() {
	make install
	echo "add de_CH.multi" > "${TERMUX_PREFIX}/lib/aspell-0.60/swiss.alias"
}
