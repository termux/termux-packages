TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libsigsegv/
TERMUX_PKG_DESCRIPTION="GNU libsigsegv is a library for handling page faults in user mode"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.16"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/libsigsegv/libsigsegv-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f8b2fac06c091fc29d6474733d118dc163ed7cd6be4783240d31ad7af11efa30
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
sv_cv_fault_posix=yes
sv_cv_leave_handler_longjmp=yes
"
TERMUX_PKG_BREAKS="libsigsegv-dev"
TERMUX_PKG_REPLACES="libsigsegv-dev"
