TERMUX_PKG_HOMEPAGE=https://www.tug.org/texlive/
TERMUX_PKG_DESCRIPTION="TeX Live is a distribution of the TeX typesetting system. This package contains architecture dependent binaries."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=20210325
_SVN_VERSION=58837
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/TeX-Live/texlive-source/archive/svn${_SVN_VERSION}.tar.gz
TERMUX_PKG_SHA256=0afa6919e44675b7afe0fa45344747afef07b6ee98eeb14ff6a2ef78f458fc12
TERMUX_PKG_DEPENDS="libc++, libiconv, freetype, libpng, libgd, libgmp, libmpfr, libicu, liblua52, libgraphite, harfbuzz, harfbuzz-icu, teckit, libpixman, libcairo, zlib, zziplib"
# libpcre, glib, fonconfig are dependencies to libcairo. pkg-config gives an error if they are missing
# libuuid, libxml2 are needed by fontconfig
TERMUX_PKG_BUILD_DEPENDS="icu-devtools, pcre, glib, fontconfig, libuuid, libxml2"
TERMUX_PKG_BREAKS="texlive (<< 20180414), texlive-bin-dev"
TERMUX_PKG_REPLACES="texlive (<< 20170524-3), texlive-bin-dev"
TERMUX_PKG_RECOMMENDS="texlive"
TERMUX_PKG_HOSTBUILD=true

TL_ROOT=$TERMUX_PREFIX/share/texlive
TL_BINDIR=$TERMUX_PREFIX/bin/texlive

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
RANLIB=ranlib
--mandir=$TERMUX_PREFIX/share/man
--infodir=$TERMUX_PREFIX/share/info
--bindir=$TL_BINDIR
--datarootdir=$TL_ROOT
--build=$TERMUX_BUILD_TUPLE
--disable-ttfdump
--enable-makeindexk
--disable-makejvf
--disable-mendexk
--disable-musixtnt
--disable-ps2pk
--disable-seetexk
--disable-gregorio
--disable-native-texlive-build
--disable-bibtexu
--enable-dvisvgm
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
--with-system-zlib
--with-system-lua
--with-system-teckit
--with-system-zziplib
--without-x
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
}

termux_step_pre_configure() {
	# When building against libicu 59.1 or later we need c++11:
	CXXFLAGS+=" -std=c++11"
	export TANGLE=$TERMUX_PKG_HOSTBUILD_DIR/texk/web2c/tangle
	export TANGLEBOOT=$TERMUX_PKG_HOSTBUILD_DIR/texk/web2c/tangleboot
	export CTANGLE=$TERMUX_PKG_HOSTBUILD_DIR/texk/web2c/ctangle
	export CTANGLEBOOT=$TERMUX_PKG_HOSTBUILD_DIR/texk/web2c/ctangleboot
	export TIE=$TERMUX_PKG_HOSTBUILD_DIR/texk/web2c/tie
	export OTANGLE=$TERMUX_PKG_HOSTBUILD_DIR/texk/web2c/otangle
}
