TERMUX_PKG_HOMEPAGE=http://utfcpp.sourceforge.net/
TERMUX_PKG_DESCRIPTION="UTF8-CPP: UTF-8 with C++ in a Portable Way"
TERMUX_PKG_VERSION=2.3.4
TERMUX_PKG_SRCURL=http://pkgs.fedoraproject.org/repo/extras/utf8cpp/utf8_v2_3_4.zip/c5e9522fde3debcad5e8922d796b2bd0/utf8_v2_3_4.zip
TERMUX_PKG_SHA256=3373cebb25d88c662a2b960c4d585daf9ae7b396031ecd786e7bb31b15d010ef
TERMUX_PKG_FOLDERNAME="source"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_NO_DEVELSPLIT=yes

termux_step_make_install(){
	cp * -r $TERMUX_PREFIX/include
}
