TERMUX_PKG_HOMEPAGE=https://gitlab.com/berdyansk/astra-sm
TERMUX_PKG_DESCRIPTION="Software for digital TV broadcasting"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=44bcd2852b7f315233267f639730e0e21b9b6c22
TERMUX_PKG_VERSION=2019.06.19
TERMUX_PKG_SRCURL=git+https://github.com/OpenVisionE2/astra-sm
TERMUX_PKG_SHA256=635bcda7c024adee99c540bcae10cba16946c54108817ac2f3a6f36305b29e85
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_GIT_BRANCH=staging
TERMUX_PKG_DEPENDS="libdvbcsa, liblua53"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-lua-includes=$TERMUX_PREFIX/include/lua5.3
--with-lua-libs=$TERMUX_PREFIX/lib/liblua5.3.so
--with-lua-compiler=no
--with-ffmpeg=no
--with-libcrypto=no
"

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
	autoreconf -fi
}
