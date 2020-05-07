TERMUX_PKG_HOMEPAGE=http://jetmore.org/john/code/swaks/
TERMUX_PKG_DESCRIPTION="Swiss Army Knife for SMTP"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=20190914.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://jetmore.org/john/code/swaks/files/swaks-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=5733a51a5c3f74f62274c17dc825f177c22ed52703c97c3b23a5354d7ec15c89
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	install -Dm700 swaks "$TERMUX_PREFIX"/bin/swaks
	cd doc
	pod2man ref.pod swaks.1
	install -Dm600 swaks.1 "$TERMUX_PREFIX"/share/man/man1/swaks.1
}
