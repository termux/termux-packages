TERMUX_PKG_HOMEPAGE=https://github.com/gogakoreli/snake
TERMUX_PKG_DESCRIPTION="Eat as much as you want while avoiding walls"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Tipz Team @TipzTeam"
_COMMIT=a57f7f8aa8c77fcce2dabafca1a5ec4b96825231
TERMUX_PKG_VERSION=2022.11.07
TERMUX_PKG_SRCURL=git+https://github.com/gogakoreli/snake
TERMUX_PKG_SHA256=3fc981af52289eaac169944de362e20d4fe6260a41158f5a8a44741e1522b89b
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_GROUPS="games"

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
	install -Dm755 -t $TERMUX_PREFIX/bin/ snake
}

termux_step_install_license() {
	install -Dm644 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/ \
		$TERMUX_PKG_BUILDER_DIR/LICENSE
}
