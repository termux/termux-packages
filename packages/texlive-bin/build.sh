TERMUX_PKG_HOMEPAGE=https://www.tug.org/texlive/
TERMUX_PKG_DESCRIPTION="TeX Live is a distribution of the TeX typesetting system."
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=20170524
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL=ftp://tug.org/historic/systems/texlive/${TERMUX_PKG_VERSION:0:4}/texlive-${TERMUX_PKG_VERSION}-source.tar.xz
TERMUX_PKG_SHA256="0161695304e941334dc0b3b5dabcf8edf46c09b7bc33eea8229b5ead7ccfb2aa"
TERMUX_PKG_DEPENDS="freetype, libpng, libgd, libgmp, libmpfr, libicu, liblua, poppler, libgraphite, harfbuzz-icu, perl"
TERMUX_PKG_BUILD_DEPENDS="icu-devtools"
TERMUX_PKG_BREAKS="texlive (<< 20170524-3)"
TERMUX_PKG_REPLACES="texlive (<< 20170524-3)"
TERMUX_PKG_RECOMMENDS="texlive"
TERMUX_PKG_NO_DEVELSPLIT=yes

TL_ROOT=$TERMUX_PREFIX/opt/texlive/${TERMUX_PKG_VERSION:0:4}
TL_BINDIR=$TL_ROOT/bin/custom

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
AR=ar \
RANLIB=ranlib \
BUILDAR=ar \
BUILDRANLIB=ranlib \
ac_cv_c_bigendian=no \
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
--without-x \
--with-banner-add=/Termux"

# These files are provided by texlive:
TERMUX_PKG_RM_AFTER_INSTALL="
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/texconfig/tcfmgr.map
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/texconfig/tcfmgr
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/web2c/texmf.cnf
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/web2c/mktex.opt
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/web2c/mktexdir.opt
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/web2c/mktexnam.opt
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/web2c/fmtutil.cnf
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/web2c/mktexdir
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/web2c/mktexnam
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/web2c/mktexupd
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/dvipdfmx/dvipdfmx.cfg
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/dvips/base/color.pro
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/dvips/base/crop.pro
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/dvips/base/finclude.pro
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/dvips/base/hps.pro
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/dvips/base/special.pro
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/dvips/base/tex.pro
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/dvips/base/texps.pro
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/dvips/base/texc.pro
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/dvips/gsftopk/render.ps
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/scripts/texlive/allcm.sh
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/scripts/texlive/allneeded.sh
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/scripts/texlive/dvi2fax.sh
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/scripts/texlive/dvired.sh
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/scripts/texlive/kpsetool.sh
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/scripts/texlive/kpsewhere.sh
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/scripts/texlive/texconfig-dialog.sh
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/scripts/texlive/texconfig-sys.sh
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/scripts/texlive/texconfig.sh
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/scripts/texlive/texlinks.sh
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/scripts/texlive/fmtutil-sys.sh
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/scripts/texlive/fmtutil.pl
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/scripts/texlive/tlmgr.pl
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/scripts/texlive/updmap-sys.sh
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/scripts/texlive/updmap.pl
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/scripts/simpdftex/simpdftex
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/fonts/cmap/dvipdfmx/EUC-UCS2
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/fonts/map/glyphlist/pdfglyphlist.txt
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/fonts/map/glyphlist/glyphlist.txt
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/fonts/map/glyphlist/texglyphlist.txt
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/fonts/map/dvipdfmx/cid-x.map
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/fonts/enc/dvips/base/7t.enc
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/scripts/luaotfload/luaotfload-tool.lua
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/scripts/oberdiek/pdfatfi.pl
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/scripts/lua2dox/lua2dox_filter
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/scripts/context/perl/mptopdf.pl
opt/texlive/${TERMUX_PKG_VERSION:0:4}/texmf-dist/scripts/checkcites/checkcites.lua"

termux_step_pre_configure() {
	# When building against libicu 59.1 or later we need c++11:
	CXXFLAGS+=" -std=c++11"
}

termux_step_post_make_install () {
	# Add bin dir to path for new shells (doesn't work for zsh and others)
	mkdir -p $TERMUX_PREFIX/etc/profile.d/
	echo "#!$TERMUX_PREFIX/bin/sh" > $TERMUX_PREFIX/etc/profile.d/texlive.sh
	echo "export TMPDIR=$TERMUX_PREFIX/tmp" >> $TERMUX_PREFIX/etc/profile.d/texlive.sh
	echo "export PATH=\$PATH:$TL_BINDIR" >> $TERMUX_PREFIX/etc/profile.d/texlive.sh
	chmod 0744 $TERMUX_PREFIX/etc/profile.d/texlive.sh
	# Replace tlmgr link with a small wrapper that prevents common break on "tlmgr update --self"
	mv $TL_BINDIR/tlmgr $TL_BINDIR/tlmgr.ln
	echo "#!$TERMUX_PREFIX/bin/sh" > $TL_BINDIR/tlmgr
	echo "termux-fix-shebang $TL_ROOT/texmf-dist/scripts/texlive/tlmgr.pl" >> $TL_BINDIR/tlmgr
	echo "sed -E -i '"'s@`/bin/sh@`'$TERMUX_PREFIX"/bin/sh@g' ${TL_ROOT}/tlpkg/TeXLive/TLUtils.pm" >> $TL_BINDIR/tlmgr
	echo 'tlmgr.ln "$@"' >> $TL_BINDIR/tlmgr
	chmod 0744 $TL_BINDIR/tlmgr
}

termux_step_create_debscripts () {
	# Clean texlive's folder if needed (run on fresh install)
	echo "#!$TERMUX_PREFIX/bin/bash" > preinst
	echo "if [ ! -f $TERMUX_PREFIX/opt/texlive/2016/install-tl -a ! -f $TERMUX_PREFIX/opt/texlive/2017/install-tl ]; then exit 0; else echo 'Removing residual files from old version of TeX Live for Termux'; fi" >> preinst
	echo "rm -rf $TERMUX_PREFIX/etc/profile.d/texlive.sh" >> preinst
	echo "rm -rf $TERMUX_PREFIX/opt/texlive/2016" >> preinst
	# Let's not delete the previous texmf-dist so that people who have installed a full distribution won't need to download everything again
	echo "shopt -s extglob" >> preinst # !(texmf-dist) is an extended glob which is turned off in scripts
	echo "rm -rf $TERMUX_PREFIX/opt/texlive/2017/!(texmf-dist)" >> preinst
	echo "shopt -u extglob" >> preinst # disable extglob again just in case
	echo "exit 0" >> preinst
	chmod 0755 preinst
}
