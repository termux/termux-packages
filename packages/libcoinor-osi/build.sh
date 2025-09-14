TERMUX_PKG_HOMEPAGE=https://github.com/coin-or/Osi
TERMUX_PKG_DESCRIPTION="An abstract base class to a generic linear programming (LP) solver"
TERMUX_PKG_LICENSE="EPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:0.108.8
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/coin-or/Osi/archive/refs/tags/releases/${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=8b01a49190cb260d4ce95aa7e3948a56c0917b106f138ec0a8544fadca71cf6a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_DEPENDS="libc++, libcoinor-utils"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
