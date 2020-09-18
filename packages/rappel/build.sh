TERMUX_PKG_HOMEPAGE=https://github.com/yrp604/rappel
TERMUX_PKG_DESCRIPTION="Rappel is a pretty janky assembly REPL."
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_SRCURL=https://github.com/yrp604/rappel.git
TERMUX_PKG_VERSION=latest
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libedit,binutils"
TERMUX_PKG_BUILD_IN_SRC=true

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

	make ARCH=$_ARCH LDFLAGS=$LDFLAGS -j $TERMUX_MAKE_PROCESSES
}

termux_step_make_install() {
	cd bin
	install -Dm755 -t "$TERMUX_PREFIX/bin" rappel
}
