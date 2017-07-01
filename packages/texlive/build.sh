TERMUX_PKG_HOMEPAGE=https://www.tug.org/texlive/
TERMUX_PKG_DESCRIPTION="TeX Live is a distribution of the TeX typesetting system."
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
_MAJOR_VERSION=20170524
_MINOR_VERSION=
TERMUX_PKG_VERSION=${_MAJOR_VERSION}${_MINOR_VERSION}
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=ftp://tug.org/historic/systems/texlive/${TERMUX_PKG_VERSION:0:4}/texlive-${TERMUX_PKG_VERSION}-source.tar.xz
TERMUX_PKG_SHA256="0161695304e941334dc0b3b5dabcf8edf46c09b7bc33eea8229b5ead7ccfb2aa"
TERMUX_PKG_DEPENDS="freetype, libpng, libgd, libgmp, libmpfr, libicu, liblua, poppler, libgraphite, harfbuzz-icu, perl, xz-utils, wget, gnupg"
TERMUX_PKG_FOLDERNAME=texlive-${_MAJOR_VERSION}-source

TL_ROOT=$TERMUX_PREFIX/opt/texlive/${TERMUX_PKG_VERSION:0:4}

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
AR=ar \
RANLIB=ranlib \
BUILDAR=ar \
BUILDRANLIB=ranlib \
ac_cv_c_bigendian=no \
--prefix=$TL_ROOT \
--bindir=$TL_ROOT/bin/pkg \
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

termux_step_pre_configure() {
	# When building against libicu 59.1 or later we need c++11:
	CXXFLAGS+=" -std=c++11"
}

termux_step_post_make_install () {
	cp $TERMUX_PKG_BUILDER_DIR/termux-install-tl.sh $TERMUX_PREFIX/bin/termux-install-tl
	mkdir -p $TERMUX_PREFIX/etc/profile.d/
	echo "export PATH=\$PATH:$TERMUX_PREFIX/opt/texlive/${TERMUX_PKG_VERSION:0:4}/bin/custom/" >> $TERMUX_PREFIX/etc/profile.d/texlive.sh
	echo "export TMPDIR=$TERMUX_PREFIX/tmp/" >> $TERMUX_PREFIX/etc/profile.d/texlive.sh
	chmod 0744 $TERMUX_PREFIX/etc/profile.d/texlive.sh
}

termux_step_create_debscripts () {
        echo 'echo "========================================================"' > postinst
	echo 'echo "retrieving texlive..."' >> postinst
	echo 'echo "you can start this manually by calling termux-install-tl"' >> postinst
        echo 'echo "========================================================"' >> postinst
	echo "termux-install-tl" >> postinst
	echo "exit 0" >> postinst
	chmod 0755 postinst

	# Clean texlive's folder if needed.
	echo "if [ ! -f $TERMUX_PREFIX/opt/texlive/2016/install-tl ]; then exit 0; else echo 'Removing residual files from old version of TeX Live for Termux'; fi" > preinst
	echo "rm -rf $TERMUX_PREFIX/{etc/profile.d/texlive.sh,opt/texlive}" >> preinst
	echo "exit 0" >> preinst
	chmod 0755 preinst

	# Remove all files installed/downloaded through termux-install-tl
	echo 'if [ $1 != "remove" ]; then exit 0; fi' > prerm
	echo "echo Running texlinks --unlink" >> prerm
	echo "texlinks --unlink" >> prerm
	echo "echo Removing bin/custom and texmf-dist" >> prerm
	echo "rm -rf $TL_ROOT/{bin/custom,texmf-dist}" >> prerm
	echo "exit 0" >> prerm
	chmod 0755 prerm
}
