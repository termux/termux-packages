TERMUX_PKG_HOMEPAGE=http://aspell.net
TERMUX_PKG_DESCRIPTION="A free and open source spell checker designed to replace Ispell"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.60.8.3"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/aspell/aspell-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0534eae11132405120d11e46bf595bd5dd189bc124ba77a5dd6aae861b48a162
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
# To use the same compiled dictionaries on every platform:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-32-bit-hash-fun"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
