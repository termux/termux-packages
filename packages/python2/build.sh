TERMUX_PKG_HOMEPAGE=http://python.org/
TERMUX_PKG_DESCRIPTION="Python 2 programming language intended to enable clear programs"
TERMUX_PKG_LICENSE="PythonPL"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=2.7
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.18
TERMUX_PKG_REVISION=14
TERMUX_PKG_SRCURL=https://www.python.org/ftp/python/${TERMUX_PKG_VERSION}/Python-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=b62c0e7937551d0cc02b8fd5cb0f544f9405bafc9a54d3808ed4594812edef43
TERMUX_PKG_DEPENDS="gdbm, libandroid-posix-semaphore, libandroid-support, libbz2, libcrypt, libffi, libsqlite, ncurses, ncurses-ui-libs, openssl, readline, zlib"
TERMUX_PKG_RECOMMENDS="clang, make, pkg-config"
TERMUX_PKG_BREAKS="python2-dev"
TERMUX_PKG_REPLACES="python2-dev"
TERMUX_PKG_HOSTBUILD=true

# The flag --with(out)-pymalloc (disable/enable specialized mallocs) is enabled by default and causes m suffix versions of python.
# Set ac_cv_func_wcsftime=no to avoid errors such as "character U+ca0025 is not in range [U+0000; U+10ffff]"
# when executing e.g. "from time import time, strftime, localtime; print(strftime(str('%Y-%m-%d %H:%M'), localtime()))"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_file__dev_ptmx=yes ac_cv_file__dev_ptc=no ac_cv_func_wcsftime=no"
# Avoid trying to include <sys/timeb.h> which does not exist on android-21:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_ftime=no"
# Avoid trying to use AT_EACCESS which is not defined:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_faccessat=no"
# Do not assume getaddrinfo is buggy when cross compiling:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_buggy_getaddrinfo=no"
# Fix https://github.com/termux/termux-packages/issues/2236:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_little_endian_double=yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --build=$TERMUX_BUILD_TUPLE --with-system-ffi --without-ensurepip"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-unicode=ucs4"
TERMUX_PKG_RM_AFTER_INSTALL="
bin/smtpd.py
bin/python
bin/python-config
share/man/man1/python.1
bin/idle*
lib/python${_MAJOR_VERSION}/idlelib
lib/python${_MAJOR_VERSION}/lib-tk
lib/python${_MAJOR_VERSION}/test
lib/python${_MAJOR_VERSION}/*/test
lib/python${_MAJOR_VERSION}/*/tests
"

termux_step_host_build() {
	# We need a host-built Parser/pgen binary, copied into cross-compile build in termux_step_post_configure() below
	$TERMUX_PKG_SRCDIR/configure
	make Parser/pgen
	# We need a python$_MAJOR_VERSION binary to be picked up by configure check:
	make
	rm -f python$_MAJOR_VERSION # Remove symlink if already exists to get a newer timestamp
	ln -s python python$_MAJOR_VERSION
}

termux_step_post_configure() {
	cp $TERMUX_PKG_HOSTBUILD_DIR/Parser/pgen $TERMUX_PKG_BUILDDIR/Parser/pgen
	touch -d "next hour" $TERMUX_PKG_BUILDDIR/Parser/pgen
}

termux_step_pre_configure() {
	# Put the host-built python in path:
	export TERMUX_ORIG_PATH=$PATH
	export PATH=$TERMUX_PKG_HOSTBUILD_DIR:$PATH

	if [ $TERMUX_ARCH = i686 ] || [ $TERMUX_ARCH = arm ]; then LDFLAGS+=" -lm"; fi

	# Needed when building with clang, as setup.py only probes
	# gcc for include paths when finding headers for determining
	# if extension modules should be built (specifically, the
	# zlib extension module is not built without this):
	CPPFLAGS+=" -I$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include"
	LDFLAGS+=" -L$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib"
	if [ $TERMUX_ARCH = x86_64 ]; then LDFLAGS+=64; fi

	LDFLAGS+=" -landroid-posix-semaphore"
}

termux_step_post_make_install() {
	# Avoid file clashes with the python (3) package:
	(cd $TERMUX_PREFIX/bin
	mv 2to3 2to3-${_MAJOR_VERSION}
	mv pydoc pydoc${_MAJOR_VERSION}
	ln -sf pydoc${_MAJOR_VERSION} pydoc2)
	# Restore path which termux_step_host_build messed with
	export PATH=$TERMUX_ORIG_PATH
}

termux_step_post_massage() {
	# Verify that desired modules have been included:
	for module in _ssl bz2 zlib _curses _sqlite3; do
		if [ ! -f lib/python${_MAJOR_VERSION}/lib-dynload/${module}.so ]; then
			termux_error_exit "Python module library $module not built"
		fi
	done
}

termux_step_create_debscripts() {
	## POST INSTALL:
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "echo 'Setting up pip2...'" >> postinst
	# Fix historical mistake which removed bin/pip2 but left site-packages/pip-*.dist-info,
	# which causes ensurepip to avoid installing pip due to already existing pip install:
	echo "if [ ! -f $TERMUX_PREFIX/bin/pip2 -a -d $TERMUX_PREFIX/lib/python${_MAJOR_VERSION}/site-packages/pip-*.dist-info ]; then rm -Rf $TERMUX_PREFIX/lib/python${_MAJOR_VERSION}/site-packages/pip-*.dist-info ; fi" >> postinst
	# Setup bin/pip2:
	echo "$TERMUX_PREFIX/bin/python2 -m ensurepip --upgrade --no-default-pip" >> postinst

	## PRE RM:
	# Avoid running on update
	echo "#!$TERMUX_PREFIX/bin/sh" > prerm
	echo "if [ \"$TERMUX_PACKAGE_FORMAT\" = \"pacman\" ] && [ \"\$1\" != \"remove\" ]; then exit 0; fi" >> prerm
	# Uninstall everything installed through pip:
	echo "pip2 freeze 2> /dev/null | xargs pip2 uninstall -y > /dev/null 2> /dev/null" >> prerm
	# Cleanup *.pyc files
	echo "find $TERMUX_PREFIX/lib/python${_MAJOR_VERSION} -depth -name *.pyc -exec rm -rf {} +" >> prerm
	# Remove contents of site-packages/ folder:
	echo "rm -Rf $TERMUX_PREFIX/lib/python${_MAJOR_VERSION}/site-packages/*" >> prerm
	# Remove pip and easy_install installed by ensurepip in postinst:
	echo "rm -f $TERMUX_PREFIX/bin/pip2* $TERMUX_PREFIX/bin/easy_install-2*" >> prerm

	echo "exit 0" >> postinst
	echo "exit 0" >> prerm
	chmod 0755 postinst prerm
}
