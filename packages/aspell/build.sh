TERMUX_PKG_HOMEPAGE=http://aspell.net
TERMUX_PKG_DESCRIPTION="A free and open source spell checker designed to replace Ispell"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.60.8.2"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/aspell/aspell-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=57fe4863eae6048f72245a8575b44b718fb85ca14b9f8c0afc41b254dfd76919
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
# To use the same compiled dictionaries on every platform:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-32-bit-hash-fun"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
