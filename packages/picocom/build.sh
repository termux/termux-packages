TERMUX_PKG_HOMEPAGE=https://github.com/npat-efault/picocom
TERMUX_PKG_DESCRIPTION="A minimal dumb-terminal emulation program"
# "BSD 2-Clause" applies to bundled Linenoise library
TERMUX_PKG_LICENSE="GPL-2.0, BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt, linenoise-1.0/LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=1acf1ddabaf3576b4023c4f6f09c5a3e4b086fb8
TERMUX_PKG_VERSION=2018.04.12
TERMUX_PKG_SRCURL=git+https://github.com/npat-efault/picocom
TERMUX_PKG_GIT_BRANCH=master
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
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin pcasc pc{x,y,z}m picocom
	install -Dm600 -t $TERMUX_PREFIX/share/man/man1 picocom.1
}
