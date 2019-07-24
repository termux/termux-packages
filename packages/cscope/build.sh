TERMUX_PKG_HOMEPAGE=http://cscope.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A developers tool for browsing program code"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=15.9
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=c5505ae075a871a9cd8d9801859b0ff1c09782075df281c72c23e72115d9f159
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/cscope-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
hw_cv_func_snprintf_c99=yes
hw_cv_func_vsnprintf_c99=yes
--with-ncurses=$TERMUX_PREFIX
"

termux_step_pre_configure() {
	export LEXLIB=""
	export LIBS="-ltinfow"
}
