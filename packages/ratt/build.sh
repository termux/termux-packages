TERMUX_PKG_HOMEPAGE=https://git.sr.ht/~ghost08/ratt
TERMUX_PKG_DESCRIPTION="A tool for converting websites to rss/atom feeds"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=ff3adafce8ce29bd98221a65f87e7e10f2c7ba25
TERMUX_PKG_VERSION=2022.10.30
TERMUX_PKG_SRCURL=git+https://git.sr.ht/~ghost08/ratt
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}
