TERMUX_PKG_HOMEPAGE=https://github.com/szcnick/p7zip
TERMUX_PKG_DESCRIPTION="Command-line version of the 7zip compressed file archiver"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_VERSION=17.02
TERMUX_PKG_SRCURL=https://github.com/szcnick/p7zip/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c22310db467755241104f98943c688c5f2c854394c4aea8eef0d77fe6420228c
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	export CXXFLAGS="$CXXFLAGS -Wno-c++11-narrowing"
	cp makefile.android_arm makefile.machine
}

termux_step_make() {
	LD="$CC $LDFLAGS" CC="$CC $CFLAGS $CPPFLAGS $LDFLAGS" \
		make -j $TERMUX_MAKE_PROCESSES 7z 7za OPTFLAGS="${CXXFLAGS}" DEST_HOME=$TERMUX_PREFIX
}

termux_step_make_install() {
	chmod +x install.sh
	make install DEST_HOME=$TERMUX_PREFIX DEST_MAN=$TERMUX_PREFIX/share/man
}
