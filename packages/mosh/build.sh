TERMUX_PKG_HOMEPAGE=https://mosh.org
TERMUX_PKG_DESCRIPTION="Mobile shell that supports roaming and intelligent local echo"
TERMUX_PKG_VERSION=1.3.0~rc2
TERMUX_PKG_SRCURL=https://github.com/mobile-shell/mosh/releases/download/mosh-1.3.0-rc2/mosh-1.3.0-rc2.tar.gz
TERMUX_PKG_SHA256=8b6bff33c469ccea0438877c68774a6b2ded6fccd99b1db180222da82f0654ae
TERMUX_PKG_FOLDERNAME=mosh-1.3.0-rc2
TERMUX_PKG_DEPENDS="libandroid-support, libprotobuf, ncurses, openssl, openssh, libutil"

termux_step_pre_configure () {
	export PROTOC=$TERMUX_TOPDIR/libprotobuf/host-build/src/protoc

	cd $TERMUX_PKG_SRCDIR
	./autogen.sh
}

termux_step_post_make_install () {
	cd $TERMUX_PREFIX/bin
	mv mosh mosh.pl
	$CXX $CXXFLAGS $LDFLAGS \
		-isystem $TERMUX_PREFIX/include \
		-lutil \
		-DPACKAGE_VERSION=\"$TERMUX_PKG_VERSION\" \
		-std=c++11 -Wall -Wextra -Werror \
		$TERMUX_PKG_BUILDER_DIR/mosh.cc -o mosh
}
