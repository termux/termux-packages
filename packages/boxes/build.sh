TERMUX_PKG_HOMEPAGE=https://boxes.thomasjensen.com/
TERMUX_PKG_DESCRIPTION="A command line filter program which draws ASCII art boxes around your input text"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2.0
TERMUX_PKG_SRCURL=https://github.com/ascii-boxes/boxes/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=98b8e3cf5008f46f096d5775d129c34db9f718728bffb0f5d67ae89bb494102e
TERMUX_PKG_DEPENDS="libunistring, pcre2"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFFILES="
share/boxes/boxes-config
"

termux_step_make() {
	make -j $TERMUX_MAKE_PROCESSES \
		CC="$CC" \
		CFLAGS_ADDTL="$CFLAGS $CPPFLAGS" \
		LDFLAGS_ADDTL="$LDFLAGS"
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin out/boxes
	install -Dm600 -t $TERMUX_PREFIX/share/man/man1 doc/boxes.1
	install -Dm600 -t $TERMUX_PREFIX/share/boxes boxes-config
}
