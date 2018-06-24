TERMUX_PKG_HOMEPAGE=https://proot-me.github.io/
TERMUX_PKG_DESCRIPTION="Emulate chroot, bind mount and binfmt_misc for non-root users"
# Just bump commit and version when needed:
_COMMIT=3bc06868508b858e9dc290e29815ecd690e9cb0c
TERMUX_PKG_VERSION=5.1.107
TERMUX_PKG_REVISION=12
TERMUX_PKG_SRCURL=https://github.com/termux/proot/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=6214cc47d468c04503fd004a2c44f77986ad110857446525087389524e32b86e
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
