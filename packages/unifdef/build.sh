TERMUX_PKG_HOMEPAGE=http://dotat.at/prog/unifdef/
TERMUX_PKG_DESCRIPTION="Remove #ifdef'ed lines"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.12
TERMUX_PKG_SRCURL=https://dotat.at/prog/unifdef/unifdef-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=fba564a24db7b97ebe9329713ac970627b902e5e9e8b14e19e024eb6e278d10b
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	mkdir -p "$TERMUX_PREFIX"/share/man/man1/
	install -Dm700 unifdef "$TERMUX_PREFIX"/bin/
	install -Dm600 unifdef.1 "$TERMUX_PREFIX"/share/man/man1/
}
