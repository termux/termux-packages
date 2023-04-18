TERMUX_PKG_HOMEPAGE=https://github.com/dvorka/hstr
TERMUX_PKG_DESCRIPTION="Shell history suggest box for bash and zsh"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.0
TERMUX_PKG_SRCURL=https://github.com/dvorka/hstr/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6d523914dc3af243f5895b2e52d39e3cc53f1afed6562f34a29da4d4467ad7fa
TERMUX_PKG_DEPENDS="ncurses, readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_file__tmp_hstr_ms_wsl=no
"

termux_step_pre_configure() {
	autoreconf -fi
}
