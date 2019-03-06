TERMUX_PKG_HOMEPAGE=http://p7zip.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Command-line version of the 7zip compressed file archiver"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="Francisco Demartino @franciscod"
_COMMIT=cb41b5664314409acce9ef4ba2d8ec940660f3bf
TERMUX_PKG_VERSION=16.02
TERMUX_PKG_REVISION=3
TERMUX_PKG_SHA256=da8c5d1699bb3fa64f8513a29ee24d0e22da630d8fa11421adabbe35f13334c8
TERMUX_PKG_SRCURL=https://salsa.debian.org/debian/p7zip/-/archive/$_COMMIT/p7zip-$_COMMIT.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure() {
	while read PATCH_FILE; do
		patch -p1 -i "debian/patches/$PATCH_FILE"
	done < debian/patches/series
	unset PATCH_FILE
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
