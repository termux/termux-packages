TERMUX_PKG_HOMEPAGE=https://github.com/p7zip-project/p7zip
TERMUX_PKG_DESCRIPTION="Command-line version of the 7zip compressed file archiver"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="17.05"
TERMUX_PKG_SRCURL=https://github.com/p7zip-project/p7zip/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9473e324de6a87d89cb7ff65b0fec4ae3f147f03ffc138189c336a4650d74804
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libiconv"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	export CXXFLAGS="$CXXFLAGS $CPPFLAGS -Wno-c++11-narrowing"
	export LDFLAGS="$LDFLAGS -liconv"
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
