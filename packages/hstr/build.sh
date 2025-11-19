TERMUX_PKG_HOMEPAGE=https://github.com/dvorka/hstr
TERMUX_PKG_DESCRIPTION="Shell history suggest box for bash and zsh"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/dvorka/hstr/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e5293d4fe2502662f19c793bef416e05ac020490218e71c75a5e92919c466071
TERMUX_PKG_DEPENDS="ncurses, readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_file__tmp_hstr_ms_wsl=no
"

termux_step_pre_configure() {
	autoreconf -fi
}
