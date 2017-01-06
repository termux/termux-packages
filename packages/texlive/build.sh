TERMUX_PKG_HOMEPAGE=https://www.tug.org/texlive/
TERMUX_PKG_DESCRIPTION="TeX Live is a distribution of the TeX typesetting system."
TERMUX_PKG_VERSION=20160523
TERMUX_PKG_SRCURL=ftp://tug.org/historic/systems/texlive/2016/texlive-${TERMUX_PKG_VERSION}b-source.tar.xz
TERMUX_PKG_SHA256="a8b32ca47f0a403661a09e202f4567a995beb718c18d8f81ca6d76daa1da21ed"
TERMUX_PKG_DEPENDS="libpng,libgd,freetype,poppler,libluajit,icu"
TERMUX_PKG_FOLDERNAME=texlive-${TERMUX_PKG_VERSION}-source
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="\
AR=ar \
RANLIB=ranlib \
BUILDAR=ar \
BUILDRANLIB=ranlib \
--prefix=$TERMUX_PREFIX/local/texlive/2016 \
--bindir=$TERMUX_PREFIX/local/texlive/2016/bin/pkg \
--libdir=$TERMUX_PREFIX/lib \
--disable-native-texlive-build \
--without-x \
--build=x86_64-linux-gnu  \
--disable-multiplatform \
--disable-dialog \
--disable-psutils \
--disable-t1utils \
--disable-bibtexu \
--disable-xz  \
--without-texinfo \
--without-xdvipdfmx \
--without-texi2html \
--with-system-icu \
--with-system-poppler \
--with-system-gd \
--with-system-luajit \
--enable-luatex \
--enable-ttfdump=no \
--enable-makeindexk=no --enable-makejvf=no --enable-mendexk=no --enable-musixtnt=no --enable-ps2pk=no \
--enable-seetexk=no --enable-gregorio=no \
--with-banner-add=/termux \
     "

termux_step_post_extract_package () {        
 rm -r $TERMUX_PKG_SRCDIR/utils/pmx
}

termux_step_post_make_install () {
 cp $TERMUX_PKG_BUILDER_DIR/termux-install-tl $TERMUX_PREFIX/bin
 chmod +x $TERMUX_PREFIX/bin/termux-install-tl
 sed -E -i "s@/bin/sh@$PREFIX/bin/sh@" "$TERMUX_PREFIX/local/texlive/2016/bin/pkg/tlmgr"
}

termux_step_create_debscripts () {
 echo 'echo "retrieving texlive..."' > postinst
 echo "termux-install-tl" >> postinst	
 echo "exit 0" >> postinst	
 chmod 0755 postinst
}
