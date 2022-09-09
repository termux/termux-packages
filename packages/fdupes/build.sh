TERMUX_PKG_HOMEPAGE=https://github.com/adrianlopezroche/fdupes
TERMUX_PKG_DESCRIPTION="Duplicates file detector"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.1"
TERMUX_PKG_SRCURL=https://github.com/adrianlopezroche/fdupes/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7d12e9d28c6a5dc46ff3a37fafd65b4b84f5c19dddf630beec8d67bc158fa265
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ncurses, pcre2"

termux_step_pre_configure() {
	autoreconf --install
}
