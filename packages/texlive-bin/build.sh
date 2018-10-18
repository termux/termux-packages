TERMUX_PKG_HOMEPAGE=https://www.tug.org/texlive/
TERMUX_PKG_DESCRIPTION="TeX Live is a distribution of the TeX typesetting system. This package contains architecture dependent binaries."
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=20180414
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=ftp://tug.org/texlive/historic/${TERMUX_PKG_VERSION:0:4}/texlive-${TERMUX_PKG_VERSION}-source.tar.xz
TERMUX_PKG_SHA256="fe0036d5f66708ad973cdc4e413c0bb9ee2385224481f7b0fb229700a0891e4e"
TERMUX_PKG_DEPENDS="freetype, libpng, libgd, libgmp, libmpfr, libicu, liblua, poppler, libgraphite, harfbuzz-icu, teckit"
TERMUX_PKG_BUILD_DEPENDS="icu-devtools"
TERMUX_PKG_BREAKS="texlive (<< 20180414)"
TERMUX_PKG_REPLACES="texlive (<< 20170524-3)"
TERMUX_PKG_RECOMMENDS="texlive"
TERMUX_PKG_NO_DEVELSPLIT=yes
TERMUX_PKG_HOSTBUILD=true

TL_ROOT=$TERMUX_PREFIX/share/texlive
TL_BINDIR=$TERMUX_PREFIX/bin

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
AR=ar \
RANLIB=ranlib \
BUILDAR=ar \
BUILDRANLIB=ranlib \
--prefix=$TL_ROOT \
--bindir=$TL_BINDIR \
--datarootdir=$TL_ROOT \
--datadir=$TERMUX_PREFIX/share \
--mandir=$TERMUX_PREFIX/share/man \
--docdir=$TERMUX_PREFIX/share/doc \
--infodir=$TERMUX_PREFIX/share/info \
--libdir=$TERMUX_PREFIX/lib \
--includedir=$TERMUX_PREFIX/include \
--build=$TERMUX_BUILD_TUPLE \
--enable-ttfdump=no \
--enable-makeindexk=yes \
--enable-makejvf=no \
--enable-mendexk=no \
--enable-musixtnt=no \
--enable-ps2pk=no \
--enable-seetexk=no \
--enable-gregorio=no \
--disable-native-texlive-build \
--disable-bibtexu \
--disable-dvisvgm \
--disable-dialog \
--disable-psutils \
--disable-multiplatform \
--disable-t1utils \
--enable-luatex \
--disable-luajittex \
--disable-mflua \
--disable-mfluajit \
--disable-xz \
--disable-pmx \
--without-texinfo \
--without-xdvipdfmx \
--without-texi2html \
--with-system-cairo \
--with-system-graphite2 \
--with-system-harfbuzz \
--with-system-gd \
--with-system-gmp \
--with-system-icu \
--with-system-lua \
--with-system-mpfr \
--with-system-poppler \
--with-system-zlib \
--with-system-xpdf \
--with-system-lua \
--with-system-teckit \
--without-x \
--with-banner-add=/Termux"

# These files are provided by texlive:
TERMUX_PKG_RM_AFTER_INSTALL="
bin/tlmgr
bin/man
share/texlive/texmf-dist/texconfig/tcfmgr.map
share/texlive/texmf-dist/texconfig/tcfmgr
share/texlive/texmf-dist/web2c/mktex.opt
share/texlive/texmf-dist/web2c/mktexdir.opt
share/texlive/texmf-dist/web2c/mktexnam.opt
share/texlive/texmf-dist/web2c/fmtutil.cnf
share/texlive/texmf-dist/web2c/mktexdir
share/texlive/texmf-dist/web2c/mktexnam
share/texlive/texmf-dist/web2c/mktexupd
share/texlive/texmf-dist/dvipdfmx/dvipdfmx.cfg
share/texlive/texmf-dist/dvips/base/color.pro
share/texlive/texmf-dist/dvips/base/crop.pro
share/texlive/texmf-dist/dvips/base/finclude.pro
share/texlive/texmf-dist/dvips/base/hps.pro
share/texlive/texmf-dist/dvips/base/special.pro
share/texlive/texmf-dist/dvips/base/tex.pro
share/texlive/texmf-dist/dvips/base/texps.pro
share/texlive/texmf-dist/dvips/base/texc.pro
share/texlive/texmf-dist/dvips/gsftopk/render.ps
share/texlive/texmf-dist/scripts/texlive/allcm.sh
share/texlive/texmf-dist/scripts/texlive/allneeded.sh
share/texlive/texmf-dist/scripts/texlive/dvi2fax.sh
share/texlive/texmf-dist/scripts/texlive/dvired.sh
share/texlive/texmf-dist/scripts/texlive/kpsetool.sh
share/texlive/texmf-dist/scripts/texlive/kpsewhere.sh
share/texlive/texmf-dist/scripts/texlive/texconfig-dialog.sh
share/texlive/texmf-dist/scripts/texlive/texconfig-sys.sh
share/texlive/texmf-dist/scripts/texlive/texconfig.sh
share/texlive/texmf-dist/scripts/texlive/texlinks.sh
share/texlive/texmf-dist/scripts/texlive/fmtutil-sys.sh
share/texlive/texmf-dist/scripts/texlive/fmtutil.pl
share/texlive/texmf-dist/scripts/texlive/tlmgr.pl
share/texlive/texmf-dist/scripts/texlive/updmap-sys.sh
share/texlive/texmf-dist/scripts/texlive/updmap.pl
share/texlive/texmf-dist/scripts/simpdftex/simpdftex
share/texlive/texmf-dist/fonts/cmap/dvipdfmx/EUC-UCS2
share/texlive/texmf-dist/fonts/map/glyphlist/pdfglyphlist.txt
share/texlive/texmf-dist/fonts/map/glyphlist/glyphlist.txt
share/texlive/texmf-dist/fonts/map/glyphlist/texglyphlist.txt
share/texlive/texmf-dist/fonts/map/dvipdfmx/cid-x.map
share/texlive/texmf-dist/fonts/enc/dvips/base/7t.enc
share/texlive/texmf-dist/scripts/luaotfload/luaotfload-tool.lua
share/texlive/texmf-dist/scripts/oberdiek/pdfatfi.pl
share/texlive/texmf-dist/scripts/lua2dox/lua2dox_filter
share/texlive/texmf-dist/scripts/context/perl/mptopdf.pl
share/texlive/texmf-dist/scripts/checkcites/checkcites.lua"

termux_step_host_build () {
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
}

termux_step_create_debscripts () {
	# Clean texlive's folder if needed (run on fresh install)
	echo "#!$TERMUX_PREFIX/bin/bash" > preinst
	echo "if [ ! -d $PREFIX/opt/texlive ]; then echo 'Removing residual files from old version of TeX Live for Termux'; rm -rf $PREFIX/opt/texlive; fi" >> preinst
	echo "exit 0" >> preinst
	chmod 0755 preinst
}
