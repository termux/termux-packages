TERMUX_PKG_HOMEPAGE=https://git.gavinhoward.com/gavin/bc
TERMUX_PKG_DESCRIPTION="Unix dc and POSIX bc with GNU and BSD extensions"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="Gavin D. Howard <gavin@gavinhoward.com>"
TERMUX_PKG_VERSION="7.0.2"
TERMUX_PKG_SRCURL=https://github.com/gavinhoward/bc/releases/download/${TERMUX_PKG_VERSION}/bc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3fc050df25577ae5dee00d74109b039f48f3d3f54bbd8ddefc455a734fb2a7de
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="readline"

termux_step_configure() {
	cd $TERMUX_PKG_BUILDDIR
	# Without NLS_PATH set like this, bc will complain that the
	# locale files will not be in the right place.
	#
	# GEN_HOST=0 prevents the need for a host compiler.
	#
	# The --predefined-build-type makes bc and dc act like the GNU
	# bc and dc by default, although users can change that at
	# runtime.
	NLS_PATH=$TERMUX_PREFIX/share/locale/%L/%N GEN_HOST=0 EXECSUFFIX=-gh \
		$TERMUX_PKG_SRCDIR/configure.sh \
		--predefined-build-type=GNU --enable-readline \
		--disable-nls --prefix=$TERMUX_PREFIX
}

termux_step_make_install() {
	install -Dm700 -T bin/bc $TERMUX_PREFIX/bin/bc-gh
	ln -sf ./bc-gh $TERMUX_PREFIX/bin/dc-gh
	chmod 700 $TERMUX_PREFIX/bin/dc-gh
	install -Dm600 manuals/bc.1 $TERMUX_PREFIX/share/man/man1/bc-gh.1
	install -Dm600 manuals/dc.1 $TERMUX_PREFIX/share/man/man1/dc-gh.1
}
