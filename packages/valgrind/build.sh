TERMUX_PKG_HOMEPAGE=http://valgrind.org/
TERMUX_PKG_DESCRIPTION="Valgrind is an instrumentation framework for building dynamic analysis tools."
TERMUX_PKG_VERSION=3.12.0
TERMUX_PKG_SRCURL=http://valgrind.org/downloads/valgrind-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=67ca4395b2527247780f36148b084f5743a68ab0c850cb43e4a5b4b012cf76a1
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-tmpdir=$TERMUX_PREFIX/tmp"
# - Does not build on x86_64 due to lacking upstream support of that arch on android.
#   See https://bugs.kde.org/show_bug.cgi?id=348342
TERMUX_PKG_BLACKLISTED_ARCHES="x86_64"
# With a clang build on aarch64:
# "error: the clang compiler does not support '-mcpu=cortex-a8'":
TERMUX_PKG_CLANG=no

if [ "$TERMUX_ARCH" == "arm" ]; then
	# valgrind doesn't like arm; armv7 works, though.
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --host=armv7-linux-androideabi"
fi

