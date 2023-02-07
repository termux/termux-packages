TERMUX_PKG_HOMEPAGE=https://github.com/benlinton/slugify
TERMUX_PKG_DESCRIPTION="Bash command that converts filenames and directories to a web friendly format"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=4528e8ecc2de14f76dfc76d045635beed138fb39
TERMUX_PKG_VERSION=2016.01.23
TERMUX_PKG_SRCURL=git+https://github.com/benlinton/slugify
TERMUX_PKG_SHA256=f629ae6fb1ed2b3e51497502528996e36c135cfc81a8fc659fdc4ab73a6a4077
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

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
	fi
}

termux_step_make_install() {
	install -D slugify -t "$TERMUX_PREFIX/bin"
	install -D slugify.1 -t "$TERMUX_PREFIX/share/man/man1"
}
