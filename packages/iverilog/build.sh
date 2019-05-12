TERMUX_PKG_HOMEPAGE=http://iverilog.icarus.com/
TERMUX_PKG_DESCRIPTION="Icarus Verilog compiler and simulation tool"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"
TERMUX_PKG_VERSION=10.2
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/steveicarus/iverilog/archive/v${TERMUX_PKG_VERSION/./_}.tar.gz
TERMUX_PKG_SHA256=f54d91821223c71c70f4735a1fb2af39c62efbccdeb9b0060ea1cf9c67647ee3
TERMUX_PKG_DEPENDS="libbz2, libc++, readline, zlib"

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
	aclocal
	autoconf
}
