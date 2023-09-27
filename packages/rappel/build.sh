TERMUX_PKG_HOMEPAGE=https://github.com/yrp604/rappel
TERMUX_PKG_DESCRIPTION="Rappel is a pretty janky assembly REPL"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=b848fce5e3759f3cbeda55e3cd8dcd7321525a44
TERMUX_PKG_VERSION=2022.11.07
TERMUX_PKG_SRCURL=git+https://github.com/yrp604/rappel
TERMUX_PKG_SHA256=e3dfe84e88b7711918555e40cb88f723ee99f197795193cd5620367b29f4a56e
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="binutils-is-llvm | binutils, libedit"
TERMUX_PKG_BUILD_IN_SRC=true

# Need nasm.
TERMUX_PKG_BLACKLISTED_ARCHES="i686, x86_64"

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

termux_step_make() {
	local _ARCH

	if [ "$TERMUX_ARCH" = "i686" ]; then
		_ARCH="x86"
	elif [ "$TERMUX_ARCH" = "x86_64" ]; then
		_ARCH="amd64"
	elif [ "$TERMUX_ARCH" = "arm" ]; then
		_ARCH="armv7"
	elif [ "$TERMUX_ARCH" = "aarch64" ]; then
		_ARCH="armv8"
	else
		_ARCH=$TERMUX_ARCH
	fi

	make ARCH=$_ARCH CC="$CC $CPPFLAGS $CFLAGS" LDFLAGS="$LDFLAGS" -j $TERMUX_MAKE_PROCESSES
}

termux_step_make_install() {
	cd bin
	install -Dm755 -t "$TERMUX_PREFIX/bin" rappel
}
