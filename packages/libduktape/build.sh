TERMUX_PKG_HOMEPAGE=https://www.duktape.org/
TERMUX_PKG_DESCRIPTION="An embeddable Javascript engine with a focus on portability and compact footprint"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.7.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/svaarala/duktape/releases/download/v$TERMUX_PKG_VERSION/duktape-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=90f8d2fa8b5567c6899830ddef2c03f3c27960b11aca222fa17aa7ac613c2890
TERMUX_PKG_REPLACES="duktape (<< 2.3.0-1), libduktape-dev"
TERMUX_PKG_BREAKS="duktape (<< 2.3.0-1), libduktape-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	# Add missing NEEDED on libm.so
	sed -i 's/duktape\.c/& -lm/' Makefile.sharedlibrary

	make -f Makefile.sharedlibrary CC="${CC}" GXX="${CXX}" INSTALL_PREFIX="${TERMUX_PREFIX}" install

	make -f Makefile.cmdline CC="${CC}" GXX="${CXX}" INSTALL_PREFIX="${TERMUX_PREFIX}" duk

	install duk "${TERMUX_PREFIX}"/bin
}
