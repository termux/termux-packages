TERMUX_PKG_HOMEPAGE=http://dotat.at/prog/unifdef/
TERMUX_PKG_DESCRIPTION="Remove #ifdef'ed lines"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=2.11
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://dotat.at/prog/unifdef/unifdef-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e8483c05857a10cf2d5e45b9e8af867d95991fab0f9d3d8984840b810e132d98
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 unifdef "$TERMUX_PREFIX"/bin/
	mkdir -p "$TERMUX_PREFIX"/share/man/man1/
	install -Dm600 unifdef.1 "$TERMUX_PREFIX"/share/man/man1/
}
