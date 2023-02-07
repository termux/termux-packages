TERMUX_PKG_HOMEPAGE=https://github.com/vgmrips/vgmtools
TERMUX_PKG_DESCRIPTION="A collection of tools for the VGM file format"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=a993f82c609f259bc4f53e0f965a171cb5cf9420
TERMUX_PKG_VERSION=2022.12.28
TERMUX_PKG_SRCURL=git+https://github.com/vgmrips/vgmtools
TERMUX_PKG_SHA256=dc5fbcb6a9be12fa4c3a3a6601a146972843a09c0609c3bbebb5c09e076f195d
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libandroid-glob, libc++, zlib"

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

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
