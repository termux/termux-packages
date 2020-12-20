TERMUX_PKG_HOMEPAGE=https://github.com/yrp604/rappel
TERMUX_PKG_DESCRIPTION="Rappel is a pretty janky assembly REPL."
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2020.09.18
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/yrp604/rappel/archive/dd45bfa000efb89357d5c80a3a77550b96dee499.tar.gz
TERMUX_PKG_SHA256=c310855880051a9e0c802b74ba0c8eafddeb5bd2a930728356101e385d04d015
TERMUX_PKG_DEPENDS="binutils, libedit"
TERMUX_PKG_BUILD_IN_SRC=true

# Need nasm.
TERMUX_PKG_BLACKLISTED_ARCHES="i686, x86_64"

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
