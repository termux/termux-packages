TERMUX_PKG_HOMEPAGE=https://eradman.com/entrproject/
TERMUX_PKG_DESCRIPTION="Event Notify Test Runner - run arbitrary commands when files change"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.9"
TERMUX_PKG_SRCURL=https://eradman.com/entrproject/code/entr-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0ef2ce7db728167844a91904944cd07c7ccc6fd3041b849cad861224d106a845
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	./configure
}
