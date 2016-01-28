TERMUX_PKG_VERSION=2.26
TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/binutils/
TERMUX_PKG_DESCRIPTION="Collection of binary tools, the main ones being ld, the GNU linker, and as, the GNU assembler"
TERMUX_PKG_SRCURL=http://ftp.gnu.org/gnu/binutils/binutils-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-werror"
TERMUX_PKG_EXTRA_MAKE_ARGS="tooldir=$TERMUX_PREFIX"
TERMUX_PKG_RM_AFTER_INSTALL="share/man/man1/windmc.1 share/man/man1/windres.1 bin/ld.bfd"

termux_step_post_make_install () {
	cp $TERMUX_PKG_BUILDER_DIR/ldd $TERMUX_PREFIX/bin/ldd
}
