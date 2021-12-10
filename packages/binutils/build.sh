TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/binutils/
TERMUX_PKG_DESCRIPTION="Collection of binary tools, the main ones being ld, the GNU linker, and as, the GNU assembler"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.37
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/binutils/binutils-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=820d9724f020a3e69cb337893a0b63c2db161dadcb0e06fc11dc29eb1e84a32c
TERMUX_PKG_DEPENDS="libc++, zlib"
TERMUX_PKG_BREAKS="binutils-dev"
TERMUX_PKG_REPLACES="binutils-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gold --enable-plugins --disable-werror --with-system-zlib --enable-new-dtags"
TERMUX_PKG_EXTRA_MAKE_ARGS="tooldir=$TERMUX_PREFIX"
TERMUX_PKG_RM_AFTER_INSTALL="share/man/man1/windmc.1 share/man/man1/windres.1 bin/ld"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_GROUPS="base-devel"

# Avoid linking against libfl.so from flex if available:
export LEXLIB=

termux_step_pre_configure() {
	export CPPFLAGS="$CPPFLAGS -Wno-c++11-narrowing"

	if [ $TERMUX_ARCH_BITS = 32 ]; then
		export LIB_PATH="${TERMUX_PREFIX}/lib:/system/lib"
	else
		export LIB_PATH="${TERMUX_PREFIX}/lib:/system/lib64"
	fi

	# Force generation of manpages
	rm \
		$TERMUX_PKG_SRCDIR/binutils/doc/*.1 \
		$TERMUX_PKG_SRCDIR/binutils/doc/cxxfilt.man \
		$TERMUX_PKG_SRCDIR/gas/doc/as.1 \
		$TERMUX_PKG_SRCDIR/ld/ld.1 \
		$TERMUX_PKG_SRCDIR/gprof/gprof.1
}

termux_step_post_make_install() {
	cp $TERMUX_PKG_BUILDER_DIR/ldd $TERMUX_PREFIX/bin/ldd
	cd $TERMUX_PREFIX/bin
	# Setup symlinks as these are used when building, so used by
	# system setup in e.g. python, perl and libtool:
	for b in ar nm objdump ranlib readelf strip; do
		ln -s -f $b $TERMUX_HOST_PLATFORM-$b
	done
	ln -sf ld.bfd $TERMUX_HOST_PLATFORM-ld
	ln -sf ld.gold gold
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" = "configure" ] || [ "\$1" = "abort-upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --install \
				$TERMUX_PREFIX/bin/ld ld $TERMUX_PREFIX/bin/ld.bfd 10
		fi
	fi
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" != "upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --remove ld $TERMUX_PREFIX/bin/ld
		fi
	fi
	EOF
}
