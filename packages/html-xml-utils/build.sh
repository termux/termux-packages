TERMUX_PKG_HOMEPAGE=https://www.w3.org/Tools/HTML-XML-utils/
TERMUX_PKG_DESCRIPTION="A number of simple utilities for manipulating HTML and XML files"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=8.0
TERMUX_PKG_SRCURL=https://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=749059906c331c2c7fbaceee02466245a237b91bd408dff8f396d0734a060ae2
TERMUX_PKG_DEPENDS="libcurl, libidn2"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	aclocal
	automake
}
