TERMUX_PKG_HOMEPAGE=https://github.com/adrianlopezroche/fdupes
TERMUX_PKG_DESCRIPTION="Duplicates file detector"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=2.1.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/adrianlopezroche/fdupes/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=37b1a499f6eb8b625b45641a2600be69ef591cd1e737e75afd50aa72ac215ea4
TERMUX_PKG_DEPENDS="ncurses, pcre2"

termux_step_pre_configure() {
	autoreconf --install
}
