TERMUX_PKG_HOMEPAGE=http://python.org/
TERMUX_PKG_DESCRIPTION="Programming language intended to enable clear programs on both a small and large scale"
# lib/python3.4/lib-dynload/_ctypes.cpython-34m.so links to ffi
# openssl for ensurepip
TERMUX_PKG_DEPENDS="libandroid-support, ncurses, readline, libffi, openssl, libutil"
TERMUX_PKG_HOSTBUILD=true

_MAJOR_VERSION=3.5
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
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
# Hard links does not work on Android 6:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_linkat=no"
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
	cp $TERMUX_PKG_HOSTBUILD_DIR/Programs/_freeze_importlib $TERMUX_PKG_BUILDDIR/Programs/_freeze_importlib
	$TERMUX_TOUCH -d "next hour" $TERMUX_PKG_BUILDDIR/Parser/pgen
	$TERMUX_TOUCH -d "next hour" $TERMUX_PKG_BUILDDIR/Programs/_freeze_importlib
}

termux_step_post_make_install () {
        (cd $TERMUX_PREFIX/bin && rm -f python && ln -s python3 python)
        (cd $TERMUX_PREFIX/share/man/man1 && rm -f python.1 && ln -s python3.1 python.1)
        # Restore path which termux_step_host_build messed with
        export PATH=$TERMUX_ORIG_PATH

	# Save away pyconfig.h so that the python-dev subpackage does not take it.
	# It is required by ensurepip so bundled with the main python package.
	# Copied back in termux_step_post_massage() after the python-dev package has been built.
	mv $TERMUX_PREFIX/include/python${_MAJOR_VERSION}m/pyconfig.h $TERMUX_PKG_TMPDIR/pyconfig.h

	# This makefile is used by pip to compile C code, and thinks that ${TERMUX_HOST_PLATFORM}-gcc
	# and other prefixed tools should be used, but we want unprefixed ones.
	# Also Remove the specs flag since that is default in the gcc Termux package:
	perl -p -i -e "s|${TERMUX_HOST_PLATFORM}-||g,s|${_SPECSFLAG}||g" $TERMUX_PREFIX/lib/python${_MAJOR_VERSION}/config-${_MAJOR_VERSION}m/Makefile
}

termux_step_post_massage () {
	# Restore pyconfig.h saved away in termux_step_post_make_install() above:
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include/python${_MAJOR_VERSION}m/
	cp $TERMUX_PKG_TMPDIR/pyconfig.h $TERMUX_PREFIX/include/python${_MAJOR_VERSION}m/
	mv $TERMUX_PKG_TMPDIR/pyconfig.h $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include/python${_MAJOR_VERSION}m/

	cd $TERMUX_PKG_MASSAGEDIR
	find . -path '*/__pycache__*' -delete
}

termux_step_create_debscripts () {
	## POST INSTALL:
	echo 'echo "Setting up pip..."' > postinst
	echo "$TERMUX_PREFIX/bin/python -m ensurepip --upgrade --default-pip" >> postinst
	# Try to update pip, failing silently on e.g. network errors:
	# echo "$TERMUX_PREFIX/bin/pip install --upgrade pip > /dev/null 2> /dev/null" >> postinst
	echo "exit 0" >> postinst

	## PRE RM:
	echo "pip freeze 2> /dev/null | xargs pip uninstall -y > /dev/null 2> /dev/null" > prerm
	# Cleanup __pycache__ folders
	echo "rm -rf $TERMUX_PREFIX/lib/python${_MAJOR_VERSION}/" >> prerm
	echo "rm -f $TERMUX_PREFIX/bin/pip $TERMUX_PREFIX/bin/pip3*" >> prerm
	echo "exit 0" >> prerm

	chmod 0755 postinst prerm
}
