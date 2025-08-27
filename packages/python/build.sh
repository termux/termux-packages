TERMUX_PKG_HOMEPAGE=https://python.org/
TERMUX_PKG_DESCRIPTION="Python 3 programming language intended to enable clear programs"
# License: PSF-2.0
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.12.11"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.python.org/ftp/python/${TERMUX_PKG_VERSION}/Python-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=c30bb24b7f1e9a19b11b55a546434f74e739bb4c271a3e3a80ff4380d49f7adb
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="gdbm, libandroid-posix-semaphore, libandroid-support, libbz2, libcrypt, libexpat, libffi, liblzma, libsqlite, ncurses, ncurses-ui-libs, openssl, readline, zlib"
TERMUX_PKG_BUILD_DEPENDS="tk"
TERMUX_PKG_RECOMMENDS="python-ensurepip-wheels, python-pip"
TERMUX_PKG_SUGGESTS="python-tkinter"
TERMUX_PKG_BREAKS="python2 (<= 2.7.15), python-dev"
TERMUX_PKG_REPLACES="python-dev"
# Let "python3" will be alias to this package.
TERMUX_PKG_PROVIDES="python3"

# https://github.com/termux/termux-packages/issues/15908
TERMUX_PKG_MAKE_PROCESSES=1

_MAJOR_VERSION="${TERMUX_PKG_VERSION%.*}"

# Set ac_cv_func_wcsftime=no to avoid errors such as "character U+ca0025 is not in range [U+0000; U+10ffff]"
# when executing e.g. "from time import time, strftime, localtime; print(strftime(str('%Y-%m-%d %H:%M'), localtime()))"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_file__dev_ptmx=yes ac_cv_file__dev_ptc=no ac_cv_func_wcsftime=no"
# Avoid trying to include <sys/timeb.h> which does not exist on android-21:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_ftime=no"
# Avoid trying to use AT_EACCESS which is not defined:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_faccessat=no"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --build=$TERMUX_BUILD_TUPLE --with-system-ffi --with-system-expat --without-ensurepip"
# Hard links does not work on Android 6:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_linkat=no"
# Do not assume getaddrinfo is buggy when cross compiling:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_buggy_getaddrinfo=no"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-loadable-sqlite-extensions"
# Fix https://github.com/termux/termux-packages/issues/2236:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_little_endian_double=yes"
# Force enable posix semaphores.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_posix_semaphores_enabled=yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_sem_open=yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_sem_timedwait=yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_sem_getvalue=yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_sem_unlink=yes"
# Force enable posix shared memory.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_shm_open=yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_shm_unlink=yes"
# Assume tzset() works
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_working_tzset=yes"

TERMUX_PKG_RM_AFTER_INSTALL="
lib/python${_MAJOR_VERSION}/test
lib/python${_MAJOR_VERSION}/*/test
lib/python${_MAJOR_VERSION}/*/tests
lib/python${_MAJOR_VERSION}/site-packages/*/
"

termux_step_pre_configure() {
	# -O3 gains some additional performance on at least aarch64.
	CFLAGS="${CFLAGS/-Oz/-O3}"

	# Needed when building with clang, as setup.py only probes
	# gcc for include paths when finding headers for determining
	# if extension modules should be built (specifically, the
	# zlib extension module is not built without this):
	CPPFLAGS+=" -I$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include"
	LDFLAGS+=" -L$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib"
	if [ $TERMUX_ARCH = x86_64 ]; then LDFLAGS+=64; fi

	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		# Python's configure script fails with
		#    Fatal: you must define __ANDROID_API__
		# if __ANDROID_API__ is not defined.
		CPPFLAGS+=" -D__ANDROID_API__=$(getprop ro.build.version.sdk)"
	else
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-build-python=python$_MAJOR_VERSION"
	fi

	# For multiprocessing libs
	export LDFLAGS+=" -landroid-posix-semaphore"

	export LIBCRYPT_LIBS="-lcrypt"
}

termux_step_post_make_install() {
	(cd $TERMUX_PREFIX/bin
	ln -sf idle${_MAJOR_VERSION} idle
	ln -sf python${_MAJOR_VERSION} python
	ln -sf python${_MAJOR_VERSION}-config python-config
	ln -sf pydoc${_MAJOR_VERSION} pydoc)
	(cd $TERMUX_PREFIX/share/man/man1
	ln -sf python${_MAJOR_VERSION}.1 python.1)
}

termux_step_post_massage() {
	# Verify that desired modules have been included:
	for module in _bz2 _curses _lzma _sqlite3 _ssl _tkinter zlib; do
		if [ ! -f "${TERMUX_PREFIX}/lib/python${_MAJOR_VERSION}/lib-dynload/${module}".*.so ]; then
			termux_error_exit "Python module library $module not built"
		fi
	done
}

termux_step_create_debscripts() {
	# This is a temporary script and will therefore be removed when python is updated to 3.12
	cat <<- POSTINST_EOF > ./postinst
	#!$TERMUX_PREFIX/bin/bash

	if [[ -f "$TERMUX_PREFIX/bin/pip" && \
	 ! (("$TERMUX_PACKAGE_FORMAT" = "debian" && -f $TERMUX_PREFIX/var/lib/dpkg/info/python-pip.list) || \
	    ("$TERMUX_PACKAGE_FORMAT" = "pacman" && \$(ls $TERMUX_PREFIX/var/lib/pacman/local/python-pip-* 2>/dev/null))) ]]; then
		echo "Removing pip..."
		rm -f $TERMUX_PREFIX/bin/pip $TERMUX_PREFIX/bin/pip3* $TERMUX_PREFIX/bin/easy_install $TERMUX_PREFIX/bin/easy_install-3*
		rm -Rf $TERMUX_PREFIX/lib/python${_MAJOR_VERSION}/site-packages/pip
		rm -Rf ${TERMUX_PREFIX}/lib/python${_MAJOR_VERSION}/site-packages/pip-*.dist-info
	fi

	if [ ! -f "$TERMUX_PREFIX/bin/pip" ]; then
		echo
		echo "== Note: pip is now separate from python =="
		echo "To install, enter the following command:"
		echo "   pkg install python-pip"
		echo
	fi

	if [ -d $TERMUX_PREFIX/lib/python3.11/site-packages ]; then
		echo
		echo "NOTE: The system python package has been updated to 3.12."
		echo "NOTE: Run 'pkg upgrade' to update system python packages."
		echo "NOTE: Packages installed using pip needs to be re-installed."
		echo
	fi

	exit 0
	POSTINST_EOF

	chmod 0755 postinst

	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ]; then
		echo "post_install" > postupg
	fi
}
