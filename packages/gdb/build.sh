TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gdb/
TERMUX_PKG_DESCRIPTION="The standard GNU Debugger that runs on many Unix-like systems and works for many programming languages"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=10.1
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gdb/gdb-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=f82f1eceeec14a3afa2de8d9b0d3c91d5a3820e23e0a01bbb70ef9f0276b62c0
TERMUX_PKG_DEPENDS="libc++, liblzma, libexpat, readline, ncurses, libmpfr, python, zlib"
TERMUX_PKG_BREAKS="gdb-dev"
TERMUX_PKG_REPLACES="gdb-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-system-readline
--with-curses
--with-python=$TERMUX_PREFIX/bin/python
ac_cv_func_getpwent=no
ac_cv_func_getpwnam=no
"
TERMUX_PKG_RM_AFTER_INSTALL="share/gdb/syscalls share/gdb/system-gdbinit"
TERMUX_PKG_MAKE_INSTALL_TARGET="-C gdb install"

termux_step_pre_configure() {
	# Fix "undefined reference to 'rpl_gettimeofday'" when building:
	export gl_cv_func_gettimeofday_clobber=no
	export gl_cv_func_gettimeofday_posix_signature=yes
	export gl_cv_func_realpath_works=yes
	export gl_cv_func_lstat_dereferences_slashed_symlink=yes
	export gl_cv_func_memchr_works=yes
	export gl_cv_func_stat_file_slash=yes
	export gl_cv_func_frexp_no_libm=no
	export gl_cv_func_strerror_0_works=yes
	export gl_cv_func_working_strerror=yes
	export gl_cv_func_getcwd_path_max=yes
}
