TERMUX_PKG_HOMEPAGE=https://github.com/jart/blink
TERMUX_PKG_DESCRIPTION="Tiny x86-64 Linux emulator"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2023.04.20-git
TERMUX_PKG_REVISION=1
_COMMIT=8b17fedd4d089fa2166267acc8487ed2d1f91fe5
TERMUX_PKG_SRCURL=https://github.com/jart/blink/archive/${_COMMIT}.tar.gz
TERMUX_PKG_SHA256=2b2aa38f9202443d7cd4b2ed4df2c30da8cdff34fde1dc66a5a4126e96012566
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	LDFLAGS+=" -lm"
	./configure --prefix="$TERMUX_PREFIX"
}
