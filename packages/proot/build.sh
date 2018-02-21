TERMUX_PKG_HOMEPAGE=http://proot.me/
TERMUX_PKG_DESCRIPTION="Emulate chroot, bind mount and binfmt_misc for non-root users"
# Just bump commit and version when needed:
_COMMIT=9553bc6b65f705b26249cf70244bff9ab8e935e9
TERMUX_PKG_VERSION=5.1.107
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://github.com/termux/proot/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=8602a43aa0ce16e0f8248cde726eac11938cae78ad04b4ef75a9c62870db3cc5
TERMUX_PKG_DEPENDS="libtalloc"

termux_step_pre_configure() {
	export LD=$CC
	CPPFLAGS+=" -DARG_MAX=131072"
}

termux_step_make_install () {
	export CROSS_COMPILE=${TERMUX_HOST_PLATFORM}-

	cd $TERMUX_PKG_SRCDIR/src
	make V=1
	make install

	mkdir -p $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_SRCDIR/doc/proot/man.1 $TERMUX_PREFIX/share/man/man1/proot.1

	cp $TERMUX_PKG_BUILDER_DIR/termux-chroot $TERMUX_PREFIX/bin/
}
