TERMUX_PKG_HOMEPAGE=https://www.w3.org/Tools/HTML-XML-utils/
TERMUX_PKG_DESCRIPTION="A number of simple utilities for manipulating HTML and XML files"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="8.8"
TERMUX_PKG_SRCURL=https://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=950027e1780787ca88271570aae890e0ac9b906f764554c2dee263d4cf7b74b8
TERMUX_PKG_DEPENDS="libcurl, libiconv, libidn2"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf -fi

	CPPFLAGS+=" -D__USE_BSD"
}
