TERMUX_PKG_HOMEPAGE=http://debugmo.de/2009/04/bgrep-a-binary-grep/
TERMUX_PKG_DESCRIPTION="Binary string grep tool"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Rabby Sheikh @xploitednoob"
TERMUX_PKG_VERSION=0.2
TERMUX_PKG_SRCURL=https://github.com/tmbinc/bgrep/archive/bgrep-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=24c02393fb436d7a2eb02c6042ec140f9502667500b13a59795388c1af91f9ba
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin bgrep
}
