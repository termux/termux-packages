TERMUX_PKG_HOMEPAGE=http://concurrencykit.org/
TERMUX_PKG_DESCRIPTION="Concurrency primitives, safe memory reclamation mechanisms and non-blocking data structures for the research, design and implementation of high performance concurrent systems."
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=0.7.0
TERMUX_PKG_SRCURL=https://github.com/concurrencykit/ck/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e730cb448fb0ecf9d19bf4c7efe9efc3c04dd9127311d87d8f91484742b0da24
#TERMUX_PKG_DEPENDS=""
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	local _ARCH

	if [ "$TERMUX_ARCH" = "i686" ]; then
		_ARCH="x86"
	elif [ "$TERMUX_ARCH" = "x86_64" ]; then
		_ARCH="amd64"
        elif [ "$TERMUX_ARCH" = "arm" ]; then
                _ARCH="armv7"
	elif [ "$TERMUX_ARCH" = "aarch64" ]; then
		_ARCH="aarch64"
	else
		_ARCH=$TERMUX_ARCH
	fi
	./configure --prefix=$TERMUX_PREFIX --platform=$_ARCH
}
