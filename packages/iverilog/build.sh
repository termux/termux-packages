TERMUX_PKG_HOMEPAGE=http://iverilog.icarus.com/
TERMUX_PKG_DESCRIPTION="Icarus Verilog compiler and simulation tool"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=10.3
TERMUX_PKG_SRCURL=https://github.com/steveicarus/iverilog/archive/v${TERMUX_PKG_VERSION/./_}.tar.gz
TERMUX_PKG_SHA256=4b884261645a73b37467242d6ae69264fdde2e7c4c15b245d902531efaaeb234
TERMUX_PKG_DEPENDS="libbz2, libc++, readline, zlib"
TERMUX_PKG_BREAKS="iverilog-dev"
TERMUX_PKG_REPLACES="iverilog-dev"

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
	aclocal
	autoconf
}
