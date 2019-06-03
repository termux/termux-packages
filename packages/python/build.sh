TERMUX_PKG_HOMEPAGE=https://python.org/
TERMUX_PKG_DESCRIPTION="Python 3 programming language intended to enable clear programs"
TERMUX_PKG_LICENSE="PythonPL"
TERMUX_PKG_DEPENDS="libandroid-support, ncurses, readline, libffi, openssl, libbz2, libsqlite, gdbm, ncurses-ui-libs, libcrypt, liblzma, zlib"
# Python.h includes crypt.h:
TERMUX_PKG_DEVPACKAGE_DEPENDS="libcrypt-dev"
_MAJOR_VERSION=3.7
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.3
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=da60b54064d4cfcd9c26576f6df2690e62085123826cff2e667e72a91952d318
TERMUX_PKG_SRCURL=https://www.python.org/ftp/python/${TERMUX_PKG_VERSION}/Python-${TERMUX_PKG_VERSION}.tar.xz

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
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --build=$TERMUX_BUILD_TUPLE --with-system-ffi --without-ensurepip"
# Hard links does not work on Android 6:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_linkat=no"
# Posix semaphores are not supported on Android:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_posix_semaphores_enabled=no"
# Do not assume getaddrinfo is buggy when cross compiling:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_buggy_getaddrinfo=no"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-loadable-sqlite-extensions"
# Fix https://github.com/termux/termux-packages/issues/2236:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_little_endian_double=yes"
TERMUX_PKG_RM_AFTER_INSTALL="
bin/idle*
lib/python${_MAJOR_VERSION}/idlelib
lib/python${_MAJOR_VERSION}/tkinter
lib/python${_MAJOR_VERSION}/turtle.py
lib/python${_MAJOR_VERSION}/turtledemo
lib/python${_MAJOR_VERSION}/test
lib/python${_MAJOR_VERSION}/*/test
lib/python${_MAJOR_VERSION}/*/tests
"
TERMUX_PKG_BREAKS="python2 (<= 2.7.15)"

termux_step_pre_configure() {
	# Needed when building with clang, as setup.py only probes
	# gcc for include paths when finding headers for determining
	# if extension modules should be built (specifically, the
	# zlib extension module is not built without this):
	CPPFLAGS+=" -I$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include"
	LDFLAGS+=" -L$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib"
	if [ $TERMUX_ARCH = x86_64 ]; then LDFLAGS+=64; fi
}

termux_step_post_make_install() {
	(cd $TERMUX_PREFIX/bin
	 ln -sf python${_MAJOR_VERSION}m python${_MAJOR_VERSION}
	 ln -sf python3 python
	 ln -sf python3-config python-config
	 ln -sf pydoc3 pydoc)
	(cd $TERMUX_PREFIX/share/man/man1
	 ln -sf python3.1 python.1)

	# Save away pyconfig.h so that the python-dev subpackage does not take it.
	# It is required by ensurepip so bundled with the main python package.
	# Copied back in termux_step_post_massage() after the python-dev package has been built.
	mv $TERMUX_PREFIX/include/python${_MAJOR_VERSION}m/pyconfig.h $TERMUX_PKG_TMPDIR/pyconfig.h
}

termux_step_post_massage() {
	# Verify that desired modules have been included:
	for module in _ssl _bz2 zlib _curses _sqlite3 _lzma; do
		if [ ! -f lib/python${_MAJOR_VERSION}/lib-dynload/${module}.*.so ]; then
			termux_error_exit "Python module library $module not built"
		fi
	done

	# Restore pyconfig.h saved away in termux_step_post_make_install() above:
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include/python${_MAJOR_VERSION}m/
	cp $TERMUX_PKG_TMPDIR/pyconfig.h $TERMUX_PREFIX/include/python${_MAJOR_VERSION}m/
	mv $TERMUX_PKG_TMPDIR/pyconfig.h $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include/python${_MAJOR_VERSION}m/

	#FIXME: Is this necessary?
	find $TERMUX_PKG_MASSAGEDIR -depth -name __pycache__ -exec rm -rf {} +
}

termux_step_create_debscripts() {
	## POST INSTALL:
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo 'echo "Setting up pip..."' >> postinst
	# Fix historical mistake which removed bin/pip but left site-packages/pip-*.dist-info,
	# which causes ensurepip to avoid installing pip due to already existing pip install:
	echo "if [ ! -f $TERMUX_PREFIX/bin/pip -a -d $TERMUX_PREFIX/lib/python${_MAJOR_VERSION}/site-packages/pip-*.dist-info ]; then rm -Rf $TERMUX_PREFIX/lib/python${_MAJOR_VERSION}/site-packages/pip-*.dist-info ; fi" >> postinst
	# Setup bin/pip:
	echo "$TERMUX_PREFIX/bin/python -m ensurepip --upgrade --default-pip" >> postinst

	## PRE RM:
	# Avoid running on update
	echo "#!$TERMUX_PREFIX/bin/sh" > prerm:
	echo 'if [ $1 != "remove" ]; then exit 0; fi' >> prerm
	# Uninstall everything installed through pip:
	echo "pip freeze 2> /dev/null | xargs pip uninstall -y > /dev/null 2> /dev/null" >> prerm
	# Cleanup __pycache__ folders:
	echo "find $TERMUX_PREFIX/lib/python${_MAJOR_VERSION} -depth -name __pycache__ -exec rm -rf {} +" >> prerm
	# Remove contents of site-packages/ folder:
	echo "rm -Rf $TERMUX_PREFIX/lib/python${_MAJOR_VERSION}/site-packages/*" >> prerm
	# Remove pip and easy_install installed by ensurepip in postinst:
	echo "rm -f $TERMUX_PREFIX/bin/pip $TERMUX_PREFIX/bin/pip3* $TERMUX_PREFIX/bin/easy_install $TERMUX_PREFIX/bin/easy_install-3*" >> prerm

	echo "exit 0" >> postinst
	echo "exit 0" >> prerm
	chmod 0755 postinst prerm
}
