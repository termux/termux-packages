TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/coreutils/
TERMUX_PKG_DESCRIPTION="Chroot utility from the Coreutils"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=8.31
TERMUX_PKG_SHA256=ff7a9c918edce6b4f4b2725e3f9b37b0c4d193531cac49a48b56c4d0d3a9e9fd
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/coreutils/coreutils-${TERMUX_PKG_VERSION}.tar.xz

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
gl_cv_host_operating_system=Android
ac_cv_func_getpass=yes
--disable-xattr
--without-gmp
"

termux_step_pre_configure() {
	CPPFLAGS+=" -DDEFAULT_TMPDIR=\\\"$TERMUX_PREFIX/tmp\\\""
	CPPFLAGS+=" -D__USE_FORTIFY_LEVEL=0"
}

termux_step_make() {
	# deps for chroot.
	make lib/configmake.h
	make src/version.h
	make lib/fcntl.h
	make lib/time.h
	make lib/sys/stat.h
	make lib/selinux/context.h
	make lib/selinux/selinux.h
	make lib/unitypes.h
	make lib/unistr.h
	make lib/uniwidth.h
	make lib/stdint.h
	make lib/stdio.h
	make lib/fnmatch.h
	make lib/getopt.h
	make lib/getopt-cdefs.h

	# build standalone chroot utility.
	make src/chroot
}

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/share/man/man1
	install -Dm700 $TERMUX_PKG_BUILDDIR/src/chroot \
		$TERMUX_PREFIX/bin/
	install -Dm600 $TERMUX_PKG_SRCDIR/man/chroot.1 \
		$TERMUX_PREFIX/share/man/man1/
}
