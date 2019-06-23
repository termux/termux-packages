TERMUX_PKG_HOMEPAGE=http://p7zip.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Command-line version of the 7zip compressed file archiver"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Francisco Demartino @franciscod"
TERMUX_PKG_VERSION=16.02
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/p7zip/p7zip/${TERMUX_PKG_VERSION}/p7zip_${TERMUX_PKG_VERSION}_src_all.tar.bz2
TERMUX_PKG_SHA256=5eb20ac0e2944f6cb9c2d51dd6c4518941c185347d4089ea89087ffdd6e2341f
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure() {
	export CXXFLAGS="$CXXFLAGS -Wno-c++11-narrowing"
	cp makefile.android_arm makefile.machine
}

termux_step_make() {
	LD="$CC $LDFLAGS" CC="$CC $CFLAGS $CPPFLAGS $LDFLAGS" \
		make -j $TERMUX_MAKE_PROCESSES all3 OPTFLAGS="${CXXFLAGS}" DEST_HOME=$TERMUX_PREFIX
}

termux_step_make_install() {
	make install DEST_HOME=$TERMUX_PREFIX DEST_MAN=$TERMUX_PREFIX/share/man
}
