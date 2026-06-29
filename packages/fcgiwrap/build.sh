TERMUX_PKG_HOMEPAGE=https://github.com/gnosek/fcgiwrap
TERMUX_PKG_DESCRIPTION="A simple server for running CGI applications over FastCGI"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION="1.1.0+g99c942c"
TERMUX_PKG_SRCURL="https://github.com/gnosek/fcgiwrap/archive/${TERMUX_PKG_VERSION##*+g}.tar.gz"
TERMUX_PKG_SHA256=c72f2933669ebd21605975c5a11f26b9739e32e4f9d324fb9e1a1925e9c2ae88
TERMUX_PKG_REPOLOGY_METADATA_VERSION="${TERMUX_PKG_VERSION%%+*}"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_DEPENDS="fcgi"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--mandir=/share/man"

termux_step_pre_configure() {
	autoreconf -i
}
