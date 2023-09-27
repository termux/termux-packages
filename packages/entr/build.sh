TERMUX_PKG_HOMEPAGE=http://eradman.com/entrproject/
TERMUX_PKG_DESCRIPTION="Event Notify Test Runner - run arbitrary commands when files change"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.3
TERMUX_PKG_SRCURL=https://eradman.com/entrproject/code/entr-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=d70b44a23136b87c89bb0079452121e6afdecf6b8f4178c19f2caac3dec3662f
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	./configure
}
