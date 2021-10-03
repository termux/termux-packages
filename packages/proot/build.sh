TERMUX_PKG_HOMEPAGE=https://proot-me.github.io/
TERMUX_PKG_DESCRIPTION="Emulate chroot, bind mount and binfmt_misc for non-root users"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Just bump commit and version when needed:
_COMMIT=b56071ff3f849ee1e7981e1088e6b3f3375e04e4
TERMUX_PKG_VERSION=5.1.107
TERMUX_PKG_REVISION=45
TERMUX_PKG_SRCURL=https://github.com/termux/proot/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=1e3205d67c2b07117179eb2eba99b29103e8f3eba543ead1f0dd4cfab5257218
TERMUX_PKG_DEPENDS="libtalloc"

# Install loader in libexec instead of extracting it every time
export PROOT_UNBUNDLE_LOADER=$TERMUX_PREFIX/libexec/proot

termux_step_pre_configure() {
	CPPFLAGS+=" -DARG_MAX=131072"
}

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR/src
	make V=1
	make install

	mkdir -p $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_SRCDIR/doc/proot/man.1 $TERMUX_PREFIX/share/man/man1/proot.1

	cp $TERMUX_PKG_BUILDER_DIR/termux-chroot $TERMUX_PREFIX/bin/
}
