TERMUX_PKG_HOMEPAGE=https://www.libtom.net/LibTomCrypt/
TERMUX_PKG_DESCRIPTION="A fairly comprehensive, modular and portable cryptographic toolkit"
TERMUX_PKG_LICENSE="Public Domain, WTFPL"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.18.2
TERMUX_PKG_SRCURL=https://github.com/libtom/libtomcrypt/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d870fad1e31cb787c85161a8894abb9d7283c2a654a9d3d4c6d45a1eba59952c
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
-f makefile.shared
PREFIX=$TERMUX_PREFIX
"

termux_step_pre_configure() {
	local libtooldir=$TERMUX_PKG_TMPDIR/_libtool
	mkdir -p $libtooldir
	pushd $libtooldir
	cat > configure.ac <<-EOF
		AC_INIT
		LT_INIT
		AC_OUTPUT
	EOF
	touch install-sh
	cp "$TERMUX_SCRIPTDIR/scripts/config.sub" ./
	cp "$TERMUX_SCRIPTDIR/scripts/config.guess" ./
	autoreconf -fi
	./configure --host=$TERMUX_HOST_PLATFORM
	popd
	export LIBTOOL=$libtooldir/libtool
}
