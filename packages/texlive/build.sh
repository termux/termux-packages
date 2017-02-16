TERMUX_PKG_HOMEPAGE=https://www.tug.org/texlive/
TERMUX_PKG_DESCRIPTION="TeX Live is a distribution of the TeX typesetting system."
_MAJOR_VERSION=20160523
_MINOR_VERSION=b
TERMUX_PKG_VERSION=${_MAJOR_VERSION}${_MINOR_VERSION}
TERMUX_PKG_SRCURL=ftp://tug.org/historic/systems/texlive/${TERMUX_PKG_VERSION:0:4}/texlive-${TERMUX_PKG_VERSION}-source.tar.xz
TERMUX_PKG_SHA256="a8b32ca47f0a403661a09e202f4567a995beb718c18d8f81ca6d76daa1da21ed"
TERMUX_PKG_DEPENDS="freetype, libpng, libgd, libgmp, libmpfr, libicu, liblua, poppler, libgraphite, harfbuzz, perl, xz-utils"
TERMUX_PKG_FOLDERNAME=texlive-${_MAJOR_VERSION}-source

# change the bin directory to "$TERMUX_PREFIX/local/texlive/2016/bin/pkg" because the installer will sinlink this to the actual bin dir..
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
AR=ar \
RANLIB=ranlib \
BUILDAR=ar \
BUILDRANLIB=ranlib \
--prefix=$TERMUX_PREFIX/local/texlive/${TERMUX_PKG_VERSION:0:4} \
--bindir=$TERMUX_PREFIX/local/texlive/${TERMUX_PKG_VERSION:0:4}/bin/pkg \
--libdir=$TERMUX_PREFIX/lib \
--build=$TERMUX_BUILD_TUPLE \
--enable-ttfdump=no \
--enable-makeindexk=no \
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
--without-x \
--with-banner-add=/Termux"

termux_step_post_make_install () {
	cp $TERMUX_PKG_BUILDER_DIR/termux-install-tl $TERMUX_PREFIX/bin
}

termux_step_create_debscripts () {
	echo 'echo "retrieving texlive..."' > postinst
	echo 'echo "you can start this manually by calling termux-install-tl"' >> postinst
	echo "termux-install-tl" >> postinst
	echo "exit 0" >> postinst
	chmod 0755 postinst
}
