TERMUX_PKG_HOMEPAGE=https://fastcgi-archives.github.io/
TERMUX_PKG_DESCRIPTION="A language independent, high performant extension to CGI"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.4.7
TERMUX_PKG_SRCURL="https://github.com/FastCGI-Archives/fcgi2/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e41ddc3a473b555bdc0cbd80703dcb1f4610c1a7700d3b9d3d0c14a416e1074b
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
