TERMUX_PKG_HOMEPAGE=https://github.com/adrianlopezroche/fdupes
TERMUX_PKG_DESCRIPTION="Duplicates file detector"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.4.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/adrianlopezroche/fdupes/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2a11250ef0e9d82837dcf336853b2891732cc78e2888ccdc6b689ab7b47b0f5b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libsqlite, ncurses, pcre2"

termux_step_pre_configure() {
	autoreconf --install
}
