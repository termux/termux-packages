TERMUX_PKG_HOMEPAGE=https://github.com/dvorka/hstr
TERMUX_PKG_DESCRIPTION="Shell history suggest box for bash and zsh"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.6
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/dvorka/hstr/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=085f8a087481bcdf33e75e2fa5aaa9289931782c0bee2db3e02425b9a7d83cdf
TERMUX_PKG_DEPENDS="ncurses, readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_file__tmp_hstr_ms_wsl=no
"

termux_step_pre_configure() {
	autoreconf -fi
}
