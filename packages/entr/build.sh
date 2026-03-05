TERMUX_PKG_HOMEPAGE=https://eradman.com/entrproject/
TERMUX_PKG_DESCRIPTION="Event Notify Test Runner - run arbitrary commands when files change"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.8"
TERMUX_PKG_SRCURL=https://eradman.com/entrproject/code/entr-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dc9a2bdc556b2be900c1d8cdf432de26492de5af3ffade000d4bfd97f3122bfb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	./configure
}
