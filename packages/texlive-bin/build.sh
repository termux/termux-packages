TERMUX_PKG_HOMEPAGE=https://www.tug.org/texlive/
TERMUX_PKG_DESCRIPTION="TeX Live is a distribution of the TeX typesetting system. This package contains architecture dependent binaries."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=20190410
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/TeX-Live/texlive-source/archive/build-svn50882.tar.gz
TERMUX_PKG_SHA256=a7462f8e29163faa52ad2ac658727b60f95241449832f1a4dac8d8a406d18233
TERMUX_PKG_DEPENDS="freetype, libpng, libgd, libgmp, libmpfr, libicu, liblua, poppler, libgraphite, harfbuzz, harfbuzz-icu, teckit, libpixman, libcairo, zlib"
# libpcre, glib, fonconfig are dependencies to libcairo. pkg-config gives an error if they are missing
# libuuid, libxml2 are needed by fontconfig
TERMUX_PKG_BUILD_DEPENDS="icu-devtools, pcre-dev, glib-dev, fontconfig, libuuid-dev, libxml2-dev"
TERMUX_PKG_BREAKS="texlive (<< 20180414)"
TERMUX_PKG_REPLACES="texlive (<< 20170524-3)"
TERMUX_PKG_RECOMMENDS="texlive"
TERMUX_PKG_NO_DEVELSPLIT=yes
TERMUX_PKG_HOSTBUILD=true

TL_ROOT=$TERMUX_PREFIX/share/texlive
TL_BINDIR=$TERMUX_PREFIX/bin

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
RANLIB=ranlib
--mandir=$TERMUX_PREFIX/share/man
--infodir=$TERMUX_PREFIX/share/info
--datarootdir=$TL_ROOT
--build=$TERMUX_BUILD_TUPLE
--enable-ttfdump=no
--enable-makeindexk=yes
--enable-makejvf=no
--enable-mendexk=no
--enable-musixtnt=no
--enable-ps2pk=no
--enable-seetexk=no
--enable-gregorio=no
--disable-native-texlive-build
--disable-bibtexu
--disable-dvisvgm
--disable-dialog
--disable-psutils
--disable-multiplatform
--disable-t1utils
--enable-luatex
--disable-luajittex
--disable-mflua
--disable-mfluajit
--disable-xz
--disable-pmx
--without-texinfo
--without-xdvipdfmx
--without-texi2html
--with-system-cairo
--with-system-graphite2
--with-system-harfbuzz
--with-system-gd
--with-system-gmp
--with-system-icu
--with-system-mpfr
--with-system-poppler
--with-system-zlib
--with-system-xpdf
--with-system-lua
--with-system-teckit
--without-x
--with-banner-add=/Termux"

# These files are provided by texlive:
TERMUX_PKG_RM_AFTER_INSTALL="
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
share/texlive/texmf-dist/hbf2gf"

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
}

termux_step_pre_configure() {
	# When building against libicu 59.1 or later we need c++11:
	CXXFLAGS+=" -std=c++11"
	export TANGLE=$TERMUX_PKG_HOSTBUILD_DIR/texk/web2c/tangle
	export TANGLEBOOT=$TERMUX_PKG_HOSTBUILD_DIR/texk/web2c/tangleboot
	export CTANGLE=$TERMUX_PKG_HOSTBUILD_DIR/texk/web2c/ctangle
	export CTANGLEBOOT=$TERMUX_PKG_HOSTBUILD_DIR/texk/web2c/ctangleboot
	export TIE=$TERMUX_PKG_HOSTBUILD_DIR/texk/web2c/tie
	export OTANGLE=$TERMUX_PKG_HOSTBUILD_DIR/texk/web2c/.libs/otangle
	# otangle is linked against libkpathsea but can't find it, so we use LD_LIBRARY_PATH
	export LD_LIBRARY_PATH=$TERMUX_PKG_HOSTBUILD_DIR/texk/kpathsea/.libs

	find "$TERMUX_PKG_SRCDIR"/texk/web2c/luatexdir -type f -exec sed -i \
	     -e 's|gTrue|true|g' \
	     -e 's|gFalse|false|g' \
	     -e 's|GBool|bool|g' \
	     -e 's|getCString|c_str|g' \
	     -e 's|Guint|unsigned int|g' \
	     -e 's|Guchar|unsigned char|g' \
	     {} +

	# These files are from upstream master:
	cp "$TERMUX_PKG_BUILDER_DIR"/pdftoepdf-poppler0.76.0.cc "$TERMUX_PKG_SRCDIR"/texk/web2c/pdftexdir/pdftoepdf.cc # commit 473d82b
	cp "$TERMUX_PKG_BUILDER_DIR"/pdftosrc-poppler0.76.0.cc "$TERMUX_PKG_SRCDIR"/texk/web2c/pdftexdir/pdftosrc.cc # commit 473d82b
}
