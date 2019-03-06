TERMUX_PKG_HOMEPAGE=http://p7zip.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Command-line version of the rar module for p7zip"
TERMUX_PKG_LICENSE="LGPL-2.0"
_COMMIT=9993b063e7a63a34b60c67c4fef5effb7f50b504
TERMUX_PKG_VERSION=16.02
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=ece543254137195ccf60c4113f968599fe1bb5a689094a8147f9bc2317819ae7
TERMUX_PKG_SRCURL=https://salsa.debian.org/debian/p7zip-rar/-/archive/$_COMMIT/p7zip-rar-$_COMMIT.tar.bz2
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
		make -j $TERMUX_MAKE_PROCESSES all OPTFLAGS="${CXXFLAGS}" DEST_HOME=$TERMUX_PREFIX
}

termux_step_make_install() {
	install -Dm775 -t "$TERMUX_PREFIX"/lib/p7zip/Codecs/Rar.so \
		"$TERMUX_PKG_SRCDIR"/bin/Codecs/Rar.so
}
