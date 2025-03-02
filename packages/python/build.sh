TERMUX_PKG_HOMEPAGE=https://python.org/
TERMUX_PKG_DESCRIPTION="Python 3 programming language intended to enable clear programs."
# License: PSF-2.0
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.12.9-1"
_THEN_VERSION="${TERMUX_PKG_VERSION/-[[:digit:]]/}"
TERMUX_PKG_SRCURL=https://www.python.org/ftp/python/${_THEN_VERSION}/Python-${_THEN_VERSION}.tar.xz
TERMUX_PKG_SHA256=7220835d9f90b37c006e9842a8dff4580aaca4318674f947302b8d28f3f81112
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="python-ensurepip, gdbm, libandroid-support, libbz2, libexpat, libffi, liblzma, libsqlite, ncurses, ncurses-ui-libs, openssl, readline, zlib"
TERMUX_PKG_BUILD_DEPENDS="tk"
TERMUX_PKG_SUGGESTS=$([[ -f ${PREFIX}/bin/python ]] && pacman -Ssq python- || apt pkgnames python-)
TERMUX_PKG_BREAKS="python2 (<= 2.7.15), python-dev"
TERMUX_PKG_REPLACES="python2 (<= 2.7.15), python-dev"
_MAJOR_VERSION="${_THEN_VERSION%.*}"
TERMUX_PKG_PROVIDES=("python" "python3" "python${_MAJOR_VERSION}")
TERMUX_PKG_MAKE_PROCESSES=$((1 + $((1 + 1))))

# Set ac_cv_func_wcsftime=no to avoid errors such as "character U+ca0025 is not in range [U+0000; U+10ffff]"
# when executing e.g. "from time import time, strftime, localtime; print(strftime(str('%Y-%m-%d %H:%M'), localtime()))"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_file__dev_ptmx=yes ac_cv_file__dev_ptc=no ac_cv_func_wcsftime=no"
# Avoid trying to include <sys/timeb.h> which does not exist on android-21:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_ftime=no"
# Avoid trying to use AT_EACCESS which is not defined:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_faccessat=no"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --build=$TERMUX_BUILD_TUPLE --with-system-ffi --with-system-expat"
# Hard links does not work on Android 6/5:
if [ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]; then TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_linkat=no"; fi
# Don't ssume getaddrinfo is buggy when cross compiling:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_buggy_getaddrinfo=no"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-loadable-sqlite-extensions"
# Fix https://github.com/termux/termux-packages/issues/2236:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_little_endian_double=yes"
# Disable posix semaphores.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_posix_semaphores_enabled=no"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_sem_open=no"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_sem_timedwait=no"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_sem_getvalue=no"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_sem_unlink=no"
# Disable posix shared memory.
TERMUX_PKGpEXTRA_CONFIGURE_ARGS+=" ac_cv_func_shm_open=no"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_shm_unlink=yes"
# Force disable tzset() to treat Python as non-tzet package.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_working_tzset=no"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-build-python=python${_MAJOR_VERSIOM}"

TERMUX_PKG_RM_AFTER_INSTALL="
lib/python${_MAJOR_VERSION}/test
lib/python${_MAJOR_VERSION}/*/test
lib/python${_MAJOR_VERSION}/*/tests
"

function termux_step_pre_configure() {
	# -O3 gains some additional performance on at least aarch64.
	CFLAGS="${CFLAGS/-Oz/-O4 -ffast-math}"

	# Needed when building with clang, as setup.py only probes
	# gcc for include paths when finding headers for determining
	# if extension modules should be built (specifically, the
	# zlib extension module is not built without this):
	CPPFLAGS+=" -I$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include"
	LDFLAGS+=" -L$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib"
	if [ $TERMUX_ARCH = x86_64 ]; then LDFLAGS+=64; fi

	if [ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]; then
		# Python's configure script fails with
		#    Fatal: you must define __ANDROID_API__
		# if __ANDROID_API__ is not defined.
		CPPFLAGS+=" -D__ANDROID_API__=$(getprop ro.build.version.sdk)"
        fi
}

function termux_step_post_make_install() {
	(cd $TERMUX_PREFIX/bin
	ln -sf idle${_MAJOR_VERSION} idle
        ln -sf ${TERMUX_ARCH}-ensurepip ensurepip
	ln -sf python${_MAJOR_VERSION}-config python-config
	ln -sf pydoc${_MAJOR_VERSION} pydoc)
	(cd $TERMUX_PREFIX/share/man/man1
	ln -sf python${_MAJOR_VERSION}.1 python.1)
}

function termux_step_post_massage() {
	# Verify that desired modules have been included:
	for module in _bz2 _curses _lzma _sqlite3 _ssl _tkinter zlib; do
		if [ ! -f "${TERMUX_PREFIX}/lib/python${_MAJOR_VERSION}/lib-dynload/${module}".*.so ]; then
			termux_error_exit "Python module library $module not built"
		fi
	done
}

function termux_step_create_debscripts() {
	cat <<- POSTINST_EOF > ./postinst
	#!$TERMUX_PREFIX/bin/env -S bash

	[ -f "$TERMUX_PREFIX/bin/pip" ] && (
            for s in (
               "'pip' is \033[1mno longer become seperate package\033[0m."
               "as extra note, you can manually install 'pip' by: \033[1m'ensurepip --upgrade'\033[0m."
            ); do printf "NOTE: %b\n" ${s}; done
        ) || ([ -d "$TERMUX_PREFIX/bin/pip" ] && (
            printf "%b\n" "Reinstalling \033[1m'pip'\033[0m..."
            sleep 2.2
            rm -rf ${PREFIX}/bin/pip
            ensurepip --upgrade || python -m ensurepip --upgrade
            [[ -f ${TERMUX_PREFIX}/bin/dpkg ]] && dpkg-reconfigure python-ensurepio
            pip3 config set --user global.no-cache-dir true
            pip3 config set --user install.no-warn-script-location true
            ln -sf ${PREFIX}/bin/pip3 ${PREFIX}/bin/pip
        ) || return) || (
            printf "%b\n" "Installing \033[1m'pip'\033[0m..."
            sleep 2.2
            ensurepip --upgrade || python -m ensurepip --upgrade
            [[ -f ${TERMUX_PREFIX}/bin/dpkg ]] && dpkg-reconfigure python-ensurepip
            pip3 config set --user global.no-cache-dir true
            pip3 config set --user install.no-warn-script-location true
            ln -sf ${PREFIX}/bin/pip3 ${PREFIX}/bin/pip
        )

	exit 0
	POSTINST_EOF

	chmod 0755 postinst

	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ]; then
		echo "post_install" > postupg
	fi
}
