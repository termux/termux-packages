TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gdb/
TERMUX_PKG_DESCRIPTION="The standard GNU Debugger that runs on many Unix-like systems and works for many programming languages"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
# This package depends on libpython${TERMUX_PYTHON_VERSION}.so.
# Please revbump and rebuild when bumping TERMUX_PYTHON_VERSION.
TERMUX_PKG_VERSION="15.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gdb/gdb-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=38254eacd4572134bca9c5a5aa4d4ca564cbbd30c369d881f733fb6b903354f2
TERMUX_PKG_DEPENDS="guile, libc++, libexpat, libgmp, libiconv, liblzma, libmpfr, libthread-db, ncurses, python, readline, zlib, zstd"
TERMUX_PKG_BREAKS="gdb-dev"
TERMUX_PKG_REPLACES="gdb-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-shared
--disable-werror
--with-system-readline
--with-system-zlib
--with-curses
--with-guile
--with-python=$TERMUX_PREFIX/bin/python
ac_cv_func_getpwent=no
ac_cv_func_getpwnam=no
"
TERMUX_PKG_RM_AFTER_INSTALL="share/gdb/syscalls share/gdb/system-gdbinit"
TERMUX_PKG_MAKE_INSTALL_TARGET="-C gdb install"

termux_step_pre_configure() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		export ac_cv_guild_program_name=/usr/bin/guild-3.0
	fi

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

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}

termux_step_post_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin gdbserver/gdbserver
}
