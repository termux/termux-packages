TERMUX_PKG_HOMEPAGE=http://www.fastcgi.com/
TERMUX_PKG_DESCRIPTION="A language independent, high performant extension to CGI"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE.TERMS"
TERMUX_PKG_VERSION=2.4.2
TERMUX_PKG_SRCURL=https://github.com/FastCGI-Archives/fcgi2/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1fe83501edfc3a7ec96bb1e69db3fd5ea1730135bd73ab152186fd0b437013bc
TERMUX_PKG_BREAKS="fcgi-dev"
TERMUX_PKG_REPLACES="fcgi-dev"

termux_step_pre_configure() {
	libtoolize --automake --copy --force
	aclocal
	autoheader
	automake --add-missing --force-missing --copy
	autoconf
	export LIBS="-lm"
}
