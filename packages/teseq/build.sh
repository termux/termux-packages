TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/teseq/
TERMUX_PKG_DESCRIPTION="Tool for analyzing control characters and terminal control sequences"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=1.1.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/teseq/teseq-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=230d2b4a587542284c415b33557a27774f5ad1580ed9db272bcd1e2034ea0589
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="teseq_cv_vsnprintf_works=yes"
