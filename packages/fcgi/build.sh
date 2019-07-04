TERMUX_PKG_HOMEPAGE=http://www.fastcgi.com/
TERMUX_PKG_DESCRIPTION="A language independent, high performant extension to CGI"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE.TERMS"
TERMUX_PKG_VERSION=2.4.0
TERMUX_PKG_SRCURL=https://sources.archlinux.org/other/packages/fcgi/fcgi-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=66fc45c6b36a21bf2fbbb68e90f780cc21a9da1fffbae75e76d2b4402d3f05b9

termux_step_pre_configure() {
	libtoolize --automake --copy --force
	aclocal
	autoheader
	automake --add-missing --force-missing --copy
	autoconf
	export LIBS="-lm"
}
