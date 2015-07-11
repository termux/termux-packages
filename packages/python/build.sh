TERMUX_PKG_HOMEPAGE=http://python.org/
TERMUX_PKG_DESCRIPTION="Programming language intended to enable clear programs on both a small and large scale"
# lib/python3.4/lib-dynload/_ctypes.cpython-34m.so links to ffi
# openssl for ensurepip
TERMUX_PKG_DEPENDS="libandroid-support, ncurses, readline, libffi, openssl"
TERMUX_PKG_HOSTBUILD=true

_MAJOR_VERSION=3.4
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.3
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://www.python.org/ftp/python/${TERMUX_PKG_VERSION}/Python-${TERMUX_PKG_VERSION}.tar.xz

# The flag --with(out)-pymalloc (disable/enable specialized mallocs) is enabled by default and causes m suffix versions of python.
# Set ac_cv_func_gethostbyname_r=no since code otherwise assumes that gethostbyaddr_r is available, which is not the case on bionic
# Set ac_cv_func_wcsftime=no to avoid errors such as "character U+ca0025 is not in range [U+0000; U+10ffff]"
# when executing e.g. "from time import time, strftime, localtime; print(strftime(str('%Y-%m-%d %H:%M'), localtime()))"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_file__dev_ptmx=yes ac_cv_file__dev_ptc=no ac_cv_func_gethostbyname_r=no ac_cv_func_fstatvfs=yes ac_cv_func_statvfs=yes ac_cv_header_sys_statvfs_h=yes ac_cv_func_wcsftime=no"
# Avoid trying to include <sys/timeb.h> which does not exist on android-21:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_ftime=no"
# Avoid trying to use AT_EACCESS which is not defined:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_faccessat=no"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --build=$TERMUX_HOST_TUPLE --disable-ipv6 --with-system-ffi --without-ensurepip"
TERMUX_PKG_RM_AFTER_INSTALL="lib/python${_MAJOR_VERSION}/test lib/python${_MAJOR_VERSION}/tkinter lib/python${_MAJOR_VERSION}/turtledemo lib/python${_MAJOR_VERSION}/idlelib bin/python${_MAJOR_VERSION}m bin/python*-config bin/idle* bin/pyvenv*"

# Python does not use CPPFLAGS when building modules, so add this to CFLAGS as well (needed when building _cursesmodule):
# export CFLAGS="$CFLAGS -isystem $TERMUX_PREFIX/include/libandroid-support"

# NOTE: termux_step_host_build may not be called if host build is cached.
export TERMUX_ORIG_PATH=$PATH
export PATH=$TERMUX_PKG_HOSTBUILD_DIR:$PATH
termux_step_host_build () {
	# We need a host-built Parser/pgen binary, copied into cross-compile build in termux_step_post_configure() below
	$TERMUX_PKG_SRCDIR/configure
	make Parser/pgen
        # We need a python$_MAJOR_VERSION binary to be picked up by configure check:
        make
        rm -f python$_MAJOR_VERSION # Remove symlink if already exists to get a newer timestamp
        ln -s python python$_MAJOR_VERSION
}

termux_step_post_configure () {
	cp $TERMUX_PKG_HOSTBUILD_DIR/Parser/pgen $TERMUX_PKG_BUILDDIR/Parser/pgen
}

termux_step_post_make_install () {
        (cd $TERMUX_PREFIX/bin && rm -f python && ln -s python3 python)
        (cd $TERMUX_PREFIX/share/man/man1 && rm -f python.1 && ln -s python3.1 python.1)
        # Restore path which termux_step_host_build messed with
        export PATH=$TERMUX_ORIG_PATH
}
