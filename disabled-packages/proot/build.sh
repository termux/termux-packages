# Fails to build with __ptrace_request being undefined
TERMUX_PKG_HOMEPAGE=http://proot.me/
TERMUX_PKG_DESCRIPTION="Emulate chroot, bind mount and binfmt_misc for non-root users"
TERMUX_PKG_VERSION=5.1.0
TERMUX_PKG_SRCURL=https://github.com/proot-me/PRoot/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=PRoot-${TERMUX_PKG_VERSION}

termux_step_make_install () {
	cd $TERMUX_PKG_SRCDIR/src
	make
	make install
}
