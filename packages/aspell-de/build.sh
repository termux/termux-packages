TERMUX_PKG_HOMEPAGE=http://aspell.net/
TERMUX_PKG_DESCRIPTION="German dictionary for aspell"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:20161207
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://j3e.de/ispell/igerman98/dict/igerman98-${TERMUX_PKG_VERSION:2}.tar.bz2
TERMUX_PKG_SHA256=17296f03c5fea62d76ecc530ebe80f6adc430278f58d472dc1842d71612960a8
TERMUX_PKG_DEPENDS="aspell"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make() {
	local LANGS="de_DE de_AT de_CH"
	for l in ${LANGS}; do
		make aspell/${l}.rws
	done
}

termux_step_make_install() {
	cd aspell

	local LANGS="de_DE de_AT de_CH"
	for l in ${LANGS}; do
		install -Dm644 -t "${TERMUX_PREFIX}/lib/aspell-0.60/" \
			${l}.alias ${l}.dat ${l}_affix.dat ${l}.multi ${l}.rws
	done
	echo "add de_DE.multi" > "${TERMUX_PREFIX}/lib/aspell-0.60/deutsch.alias"
	echo "add de_DE.multi" > "${TERMUX_PREFIX}/lib/aspell-0.60/german.alias"
	echo "add de_CH.multi" > "${TERMUX_PREFIX}/lib/aspell-0.60/swiss.alias"
}
