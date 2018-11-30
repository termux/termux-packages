TERMUX_PKG_HOMEPAGE=https://github.com/dukealexanderthefirst/calcsh
TERMUX_PKG_DESCRIPTION="calculator in a shell"
TERMUX_PKG_VERSION=0.1
TERMUX_PKG_SHA256=""
TERMUX_PKG_SRCURL=https://github.com/dukealexanderthefirst/calcsh/archive/calcsh-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	cp src/app/calcsh $TERMUX_PREFIX/bin/calcsh
}
