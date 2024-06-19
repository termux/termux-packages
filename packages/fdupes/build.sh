TERMUX_PKG_HOMEPAGE=https://github.com/adrianlopezroche/fdupes
TERMUX_PKG_DESCRIPTION="Duplicates file detector"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.3.1"
TERMUX_PKG_SRCURL=https://github.com/adrianlopezroche/fdupes/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fbf0a455d398d2bfeb86da832d736557a6ee09d0b1456b869698dc43c5cf5072
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libsqlite, ncurses, pcre2"

termux_step_pre_configure() {
	autoreconf --install
}
