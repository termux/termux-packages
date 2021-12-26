TERMUX_PKG_HOMEPAGE=https://github.com/measurement-factory/dnstop
TERMUX_PKG_DESCRIPTION="A libpcap application that displays various tables of DNS traffic on your network"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=1fc98eb479513f4be68ba500aec18934d24e8fd6
TERMUX_PKG_VERSION=2021.03.29
TERMUX_PKG_SRCURL=https://github.com/measurement-factory/dnstop.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libpcap, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local version="$(git log -1 --format=%cs | sed 's/-/./g')"
	if [ "$version" != "$TERMUX_PKG_VERSION" ]; then
		echo -n "ERROR: The specified version \"$TERMUX_PKG_VERSION\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi
	sed -i "s/@VERSION@/$version/g" dnstop.c
}

termux_step_pre_configure() {
	CPPFLAGS+=" -D__USE_BSD"
}
