TERMUX_PKG_HOMEPAGE=https://mosh.org
TERMUX_PKG_DESCRIPTION="Mobile shell that supports roaming and intelligent local echo. Bleeding edge git version."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2022.02.04
TERMUX_PKG_REVISION=2
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_SRCURL=https://github.com/mobile-shell/mosh.git
TERMUX_PKG_DEPENDS="libandroid-support, libc++, libprotobuf, ncurses, openssl, openssh, perl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFLICTS="mosh, mosh-perl"
TERMUX_PKG_REPLACES="mosh, mosh-perl"
TERMUX_PKG_PROVIDES="mosh, mosh-perl"
_COMMIT=dbe419d0e069df3fedc212d456449f64d0280c76

termux_step_pre_configure() {
	termux_setup_protobuf
	./autogen.sh
}

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout "$_COMMIT"

	local version
	version="$(git log -1 --format=%cs | sed 's/-/./g')"
	if [ "$version" != "$TERMUX_PKG_VERSION" ]; then
		echo -n "ERROR: The specified version \"$TERMUX_PKG_VERSION\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi
}
