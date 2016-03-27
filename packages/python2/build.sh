TERMUX_PKG_HOMEPAGE=http://python.org/
TERMUX_PKG_DESCRIPTION="Python 2 programming language intended to enable clear programs"
# lib/python3.4/lib-dynload/_ctypes.cpython-34m.so links to ffi.
# openssl for ensurepip.
# libbz2 for the bz2 module.
# ncurses-ui-libs for the curses.panel module.
TERMUX_PKG_DEPENDS="libandroid-support, ncurses, readline, libffi, openssl, libutil, libbz2, libsqlite, gdbm, ncurses-ui-libs"
TERMUX_PKG_HOSTBUILD=true

_MAJOR_VERSION=2.7
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.11
TERMUX_PKG_BUILD_REVISION=2
TERMUX_PKG_SRCURL=http://www.python.org/ftp/python/${TERMUX_PKG_VERSION}/Python-${TERMUX_PKG_VERSION}.tar.xz

# The flag --with(out)-pymalloc (disable/enable specialized mallocs) is enabled by default and causes m suffix versions of python.
# Set ac_cv_func_wcsftime=no to avoid errors such as "character U+ca0025 is not in range [U+0000; U+10ffff]"
# when executing e.g. "from time import time, strftime, localtime; print(strftime(str('%Y-%m-%d %H:%M'), localtime()))"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_file__dev_ptmx=yes ac_cv_file__dev_ptc=no ac_cv_func_wcsftime=no"
# Avoid trying to include <sys/timeb.h> which does not exist on android-21:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_ftime=no"
# Avoid trying to use AT_EACCESS which is not defined:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_faccessat=no"
# The gethostbyname_r function does not exist on device libc:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_gethostbyname_r=no"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --build=$TERMUX_HOST_TUPLE --disable-ipv6 --with-system-ffi --without-ensurepip"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-unicode=ucs4"

# Let 2to3 be in the python3 package:
TERMUX_PKG_RM_AFTER_INSTALL="bin/2to3"

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
	$TERMUX_TOUCH -d "next hour" $TERMUX_PKG_BUILDDIR/Parser/pgen
}

termux_step_post_make_install () {
	# Avoid file clashes with the python (3) package:
	mv $TERMUX_PREFIX/share/man/man1/{python.1,python2.1}
	rm $TERMUX_PREFIX/bin/python
        # Restore path which termux_step_host_build messed with
        export PATH=$TERMUX_ORIG_PATH

	# Used by pip to compile C code, remove the spec file flag
	# since it's built in for the on-device gcc:
	perl -p -i -e "s|${_SPECSFLAG}||g" $TERMUX_PREFIX/lib/python${_MAJOR_VERSION}/{config/Makefile,_sysconfigdata.py}
}

termux_step_create_debscripts () {
	## POST INSTALL:
	echo "echo 'Setting up pip2...'" > postinst
	echo "$TERMUX_PREFIX/bin/python2 -m ensurepip --upgrade --no-default-pip" >> postinst
	# Try to update pip, failing silently on e.g. network errors:
	#echo "$TERMUX_PREFIX/bin/pip2 install --upgrade pip" >> postinst
	echo "exit 0" >> postinst

	## PRE RM:
	echo "pip2 freeze 2> /dev/null | xargs pip2 uninstall -y > /dev/null 2> /dev/null" > prerm
	# Cleanup __pycache__ folders
	echo "rm -rf $TERMUX_PREFIX/lib/python${_MAJOR_VERSION}/" >> prerm
	echo "rm -f $TERMUX_PREFIX/bin/pip2*" >> prerm
	echo "exit 0" >> prerm

	chmod 0755 postinst prerm
}
