TERMUX_PKG_HOMEPAGE=https://github.com/alok8bb/cloneit
TERMUX_PKG_DESCRIPTION="A cli tool to download specific GitHub directories or files"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=58e9213ba5af457e76a7ea55696eb77f6d0d9025
_COMMIT_DATE=2025.07.22
TERMUX_PKG_VERSION=${_COMMIT_DATE//./}
TERMUX_PKG_SRCURL=git+https://github.com/alok8bb/cloneit
TERMUX_PKG_SHA256=69e5d916bb6ce319234102b7efef705b2be75b2041eaccce9bcfc5cdb57e1198
TERMUX_PKG_GIT_BRANCH="master"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="openssl"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local version="$(git log -1 --format=%cs | sed 's/-/./g')"
	if [ "$version" != "$_COMMIT_DATE" ]; then
		echo -n "ERROR: The specified commit date \"$_COMMIT_DATE\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files: expected=${TERMUX_PKG_SHA256}, actual=${s}"
	fi
}

termux_step_make() {
	termux_setup_rust

	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/cloneit
}
