TERMUX_PKG_HOMEPAGE=https://proot-me.github.io/
TERMUX_PKG_DESCRIPTION="Emulate chroot, bind mount and binfmt_misc for non-root users"
# Just bump commit and version when needed:
_COMMIT=bb145259590c13c4992fb34d128218f560daf0fc
TERMUX_PKG_VERSION=5.1.107
TERMUX_PKG_REVISION=16
TERMUX_PKG_SRCURL=https://github.com/termux/proot/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=aa0c5b18fbf615847cd186babf6c89c73fe4308032c50c2db9b7e6bb2220a515
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
