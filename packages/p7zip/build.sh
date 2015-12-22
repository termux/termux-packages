# adapted from archlinux PKGBUILD
pkgname=p7zip
pkgver=15.09
TERMUX_PKG_MAINTAINER="Francisco Demartino <demartino.francisco@gmail.com>"
TERMUX_PKG_VERSION=$pkgver
TERMUX_PKG_HOMEPAGE=http://p7zip.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Command-line version of the 7zip compressed file archiver"
TERMUX_PKG_SRCURL="http://downloads.sourceforge.net/project/${pkgname}/${pkgname}/${pkgver}/${pkgname}_${pkgver}_src_all.tar.bz2"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_FOLDERNAME=${pkgname}_${pkgver}

termux_step_configure () {
	cp makefile.android_arm makefile.machine

	rm GUI/kde4/p7zip_compress.desktop

	sed -i 's/wx-config/wx-config-2.8/g' CPP/7zip/TEST/TestUI/makefile \
	CPP/7zip/UI/{FileManager,GUI,P7ZIP}/makefile
}

termux_step_make () {
	LD="$CC $LDFLAGS" CC="$CC $CFLAGS $CPPFLAGS $LDFLAGS" make -j $TERMUX_MAKE_PROCESSES all3 OPTFLAGS="${CXXFLAGS}" DEST_HOME=$TERMUX_PREFIX
}

termux_step_make_install () {
	make install DEST_HOME=$TERMUX_PREFIX DEST_MAN=$TERMUX_PREFIX/share/man
}
