TERMUX_PKG_HOMEPAGE=https://pmt.sourceforge.io/pngcrush/
TERMUX_PKG_DESCRIPTION="Recompresses png files"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.8.13
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/pmt/pngcrush-${TERMUX_PKG_VERSION}-nolib.tar.xz
TERMUX_PKG_SHA256=3b4eac8c5c69fe0894ad63534acedf6375b420f7038f7fc003346dd352618350
TERMUX_PKG_DEPENDS="libpng, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="-e"

termux_step_pre_configure() {
	export LD="$CC"
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin pngcrush
}
