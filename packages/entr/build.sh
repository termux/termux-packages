TERMUX_PKG_HOMEPAGE=http://eradman.com/entrproject/
TERMUX_PKG_DESCRIPTION="Event Notify Test Runner - run arbitrary commands when files change"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.2
TERMUX_PKG_SRCURL=https://eradman.com/entrproject/code/entr-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=237e309d46b075210c0e4cb789bfd0c9c777eddf6cb30341c3fe3dbcc658c380
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	./configure
}
