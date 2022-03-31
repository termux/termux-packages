TERMUX_PKG_HOMEPAGE=https://github.com/benlinton/slugify
TERMUX_PKG_DESCRIPTION="Bash command that converts filenames and directories to a web friendly format."
TERMUX_PKG_LICENSE="MIT"
_COMMIT=4528e8ecc2de14f76dfc76d045635beed138fb39
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_SRCURL=$TERMUX_PKG_HOMEPAGE.git
TERMUX_PKG_VERSION=2016.01.23
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS=bash
TERMUX_PKG_PLATFORM_INDEPENDENT=true

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
	install -D slugify -t "$TERMUX_PREFIX/bin"
	install -D slugify.1 -t "$TERMUX_PREFIX/share/man/man1"
}
