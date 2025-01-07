TERMUX_PKG_HOMEPAGE=https://www.tug.org/texlive/
TERMUX_PKG_DESCRIPTION="TeX Live is a distribution of the TeX typesetting system. This package contains architecture dependent binaries."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=20240310
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/TeX-Live/texlive-source/archive/refs/heads/tags/texlive-${TERMUX_PKG_VERSION:0:4}.0.tar.gz
TERMUX_PKG_SHA256=26f756e5491a0619c183c91d007a91939c32c184c7ab718d4102a8b81575bc4d
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="freetype, harfbuzz, harfbuzz-icu, libc++, libcairo, libgd, libgmp, libgraphite, libiconv, libicu, liblua52, libmpfr, libpaper, libpixman, libpng, teckit, zlib, zziplib"
# libpcre, glib, fontconfig are dependencies of libcairo. pkg-config gives an error if they are missing
# libuuid, libxml2 are needed by fontconfig
TERMUX_PKG_BUILD_DEPENDS="icu-devtools, pcre, glib, fontconfig, libuuid, libxml2"
TERMUX_PKG_BREAKS="texlive (<< 20180414), texlive-bin-dev"
TERMUX_PKG_REPLACES="texlive (<< 20170524-3), texlive-bin-dev"
TERMUX_PKG_RECOMMENDS="texlive-installer"
TERMUX_PKG_HOSTBUILD=true

TL_ROOT=$TERMUX_PREFIX/share/texlive/${TERMUX_PKG_VERSION:0:4}
TL_BINDIR=$TERMUX_PREFIX/bin/texlive

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
RANLIB=ranlib
--bindir=$TL_BINDIR
--build=$TERMUX_BUILD_TUPLE
--datarootdir=$TL_ROOT
--disable-dialog
--disable-gregorio
--disable-luajittex
--disable-makejvf
--disable-mendexk
--disable-mflua
--disable-mfluajit
--disable-multiplatform
--disable-musixtnt
--disable-native-texlive-build
--disable-pmx
--disable-ps2pk
--disable-psutils
--disable-seetexk
--disable-t1utils
--disable-ttfdump
--disable-xz
--enable-dvisvgm
--enable-luatex
--enable-makeindexk
--infodir=$TERMUX_PREFIX/share/info
--mandir=$TERMUX_PREFIX/share/man
--with-system-cairo
--with-system-gd
--with-system-gmp
--with-system-graphite2
--with-system-harfbuzz
--with-system-icu
--with-system-libpaper
--with-system-lua
--with-system-mpfr
--with-system-teckit
--with-system-zlib
--with-system-zziplib
--without-texi2html
--without-texinfo
--without-x
--without-xdvipdfmx
--with-banner-add=/Termux"

# These files are provided by texlive:
TERMUX_PKG_RM_AFTER_INSTALL="
bin/a2ping
bin/tlmgr
bin/man
share/texlive/texmf-dist/web2c/mktex.opt
share/texlive/texmf-dist/web2c/mktexdir.opt
share/texlive/texmf-dist/web2c/mktexnam.opt
share/texlive/texmf-dist/web2c/fmtutil.cnf
share/texlive/texmf-dist/web2c/mktexdir
share/texlive/texmf-dist/web2c/mktexnam
share/texlive/texmf-dist/web2c/mktexupd
share/texlive/texmf-dist/web2c/texmf.cnf
share/texlive/texmf-dist/fonts
share/texlive/texmf-dist/doc
share/texlive/texmf-dist/dvips
share/texlive/texmf-dist/dvipdfmx
share/texlive/texmf-dist/texconfig
share/texlive/texmf-dist/bibtex
share/texlive/texmf-dist/scripts
share/texlive/texmf-dist/ttf2pk
share/texlive/texmf-dist/source
share/texlive/texmf-dist/chktex
share/texlive/texmf-dist/hbf2gf
"

termux_step_host_build() {
	mkdir -p auxdir/auxsub
	mkdir -p texk/kpathsea
	mkdir -p texk/web2c

	cd $TERMUX_PKG_HOSTBUILD_DIR/auxdir/auxsub
	$TERMUX_PKG_SRCDIR/auxdir/auxsub/configure
	make

	cd $TERMUX_PKG_HOSTBUILD_DIR/texk/kpathsea
	$TERMUX_PKG_SRCDIR/texk/kpathsea/configure

	cd $TERMUX_PKG_HOSTBUILD_DIR/texk/web2c
	$TERMUX_PKG_SRCDIR/texk/web2c/configure --without-x
	make tangle
	make ctangle
	make tie
	make otangle
	make himktables
}

termux_step_pre_configure() {
	export TANGLE=$TERMUX_PKG_HOSTBUILD_DIR/texk/web2c/tangle
	export TANGLEBOOT=$TERMUX_PKG_HOSTBUILD_DIR/texk/web2c/tangleboot
	export CTANGLE=$TERMUX_PKG_HOSTBUILD_DIR/texk/web2c/ctangle
	export CTANGLEBOOT=$TERMUX_PKG_HOSTBUILD_DIR/texk/web2c/ctangleboot
	export TIE=$TERMUX_PKG_HOSTBUILD_DIR/texk/web2c/tie
	export OTANGLE=$TERMUX_PKG_HOSTBUILD_DIR/texk/web2c/otangle
	export HIMKTABLES=$TERMUX_PKG_HOSTBUILD_DIR/texk/web2c/himktables

	sed -e "s%@TERMUX_PREFIX@%$TERMUX_PREFIX%g" \
		-e "s%@YEAR@%${TERMUX_PKG_VERSION:0:4}%g" \
		"$TERMUX_PKG_BUILDER_DIR"/texk-kpathsea-texmf.cnf.diff | patch --silent -p1
}
