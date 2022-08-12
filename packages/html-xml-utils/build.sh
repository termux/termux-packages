TERMUX_PKG_HOMEPAGE=https://www.w3.org/Tools/HTML-XML-utils/
TERMUX_PKG_DESCRIPTION="A number of simple utilities for manipulating HTML and XML files"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=8.4
TERMUX_PKG_SRCURL=https://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=41bb9b14e1f4cd6102e3f8dfb79e7146a24c09693869873165c421769a57d137
TERMUX_PKG_DEPENDS="libcurl, libidn2"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	aclocal
	automake
}
