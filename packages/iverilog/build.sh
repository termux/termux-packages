TERMUX_PKG_HOMEPAGE=http://iverilog.icarus.com/
TERMUX_PKG_DESCRIPTION="Icarus Verilog compiler and simulation tool"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=11.0
TERMUX_PKG_SRCURL=https://github.com/steveicarus/iverilog/archive/v${TERMUX_PKG_VERSION/./_}.tar.gz
TERMUX_PKG_SHA256=6327fb900e66b46803d928b7ca439409a0dc32731d82143b20387be0833f1c95
TERMUX_PKG_DEPENDS="libbz2, libc++, readline, zlib"
TERMUX_PKG_BREAKS="iverilog-dev"
TERMUX_PKG_REPLACES="iverilog-dev"

termux_step_pre_configure() {
	CFLAGS="${CFLAGS/-Oz/-Os}"
	LDFLAGS+=" -lm"
	aclocal
	autoconf
}
