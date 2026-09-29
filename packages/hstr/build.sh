TERMUX_PKG_HOMEPAGE=https://github.com/dvorka/hstr
TERMUX_PKG_DESCRIPTION="Shell history suggest box for bash and zsh"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.2"
TERMUX_PKG_SRCURL=https://github.com/dvorka/hstr/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bceab1cb3c3b636d9ff4dfbaf8b035530e76a36d948767ed1735c4e79d7473eb
TERMUX_PKG_DEPENDS="ncurses, readline"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_file__tmp_hstr_ms_wsl=no
"

termux_step_pre_configure() {
	autoreconf -fi
}
