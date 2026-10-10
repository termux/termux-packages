TERMUX_PKG_HOMEPAGE=http://aspell.net/
TERMUX_PKG_DESCRIPTION="English dictionary for aspell"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="Copyright"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:2026.02.25"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/aspell/dict/en/aspell6-en-${TERMUX_PKG_VERSION:2}-0.tar.bz2
TERMUX_PKG_SHA256=77a5cb437c45d1115f3b593802c20651d8c93803ed1073278dc1a1240016f10d
TERMUX_PKG_DEPENDS="aspell"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_post_massage() {
	local _PACKAGE_GUARD_FILES=(lib/aspell-0.60/en{.dat,_phonet.dat,_affix.dat,-common.rws,.multi,_AU.multi,_CA.multi,_GB.multi,_US.multi})

	local f
	for f in "${_PACKAGE_GUARD_FILES[@]}"; do
		[ -e "${f}" ] || termux_error_exit "package file guard check failed: ${f}"
	done
}

termux_step_configure() {
	cat > $TERMUX_PKG_SRCDIR/Makefile <<- EOF
	ASPELL = $(command -v aspell)
	ASPELL_FLAGS =
	PREZIP = $(command -v prezip)
	DESTDIR =
	dictdir = $TERMUX_PREFIX/lib/aspell-0.60
	datadir = $TERMUX_PREFIX/lib/aspell-0.60
	EOF
	cat $TERMUX_PKG_SRCDIR/Makefile.pre >> $TERMUX_PKG_SRCDIR/Makefile
}
