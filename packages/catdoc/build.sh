TERMUX_PKG_HOMEPAGE=http://www.wagner.pp.ru/~vitus/software/catdoc/
TERMUX_PKG_DESCRIPTION="Program which reads MS-Word file and prints readable ASCII text to stdout"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.95
TERMUX_PKG_SRCURL=http://ftp.wagner.pp.ru/pub/catdoc/catdoc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=514a84180352b6bf367c1d2499819dfa82b60d8c45777432fa643a5ed7d80796
TERMUX_PKG_DEPENDS="libandroid-glob"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
