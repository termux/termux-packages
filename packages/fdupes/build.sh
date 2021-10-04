TERMUX_PKG_HOMEPAGE=https://github.com/adrianlopezroche/fdupes
TERMUX_PKG_DESCRIPTION="Duplicates file detector"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.1.2
TERMUX_PKG_SRCURL=https://github.com/adrianlopezroche/fdupes/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=47536dad3f628b49420d60be55417238e537902a7461e19f199092ab8b24e8f1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ncurses, pcre2"

termux_step_pre_configure() {
	autoreconf --install
}
