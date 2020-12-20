TERMUX_PKG_HOMEPAGE=https://www.w3.org/Tools/HTML-XML-utils/
TERMUX_PKG_DESCRIPTION="A number of simple utilities for manipulating HTML and XML files"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=7.9
TERMUX_PKG_SRCURL=https://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d86ac96ea660316bef814c17b2a96d54cdf91c69e59614459865c2bfdaee433f
TERMUX_PKG_DEPENDS="libcurl, libidn2"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	automake
}
