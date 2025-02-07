TERMUX_PKG_HOMEPAGE=https://eradman.com/entrproject/
TERMUX_PKG_DESCRIPTION="Event Notify Test Runner - run arbitrary commands when files change"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.7"
TERMUX_PKG_SRCURL=https://eradman.com/entrproject/code/entr-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=90c5d943820c70cef37eb41a382a6ea4f5dd7fd95efef13b2b5520d320f5d067
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	./configure
}
