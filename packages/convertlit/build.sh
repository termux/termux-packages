# Dependency for ebook-tools
TERMUX_PKG_HOMEPAGE='http://www.convertlit.com/'
TERMUX_PKG_DESCRIPTION='An extractor/converter for .LIT eBooks'
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://www.convertlit.com/clit${TERMUX_PKG_VERSION/./}src.zip
TERMUX_PKG_SHA256=d70a85f5b945104340d56f48ec17bcf544e3bb3c35b1b3d58d230be699e557ba
TERMUX_PKG_BUILD_DEPENDS="libtommath-static"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_get_source() {
	termux_download "$TERMUX_PKG_SRCURL" "$TERMUX_PKG_CACHEDIR/${TERMUX_PKG_SRCURL##*/}" "$TERMUX_PKG_SHA256"
	unzip "$TERMUX_PKG_CACHEDIR/${TERMUX_PKG_SRCURL##*/}" -d $TERMUX_PKG_SRCDIR
}

termux_step_configure() {
	# Link to correct libtommath and use system LDFLAGS
	sed -e 's|../libtommath-0.30/libtommath.a|'$TERMUX_PREFIX'/lib/libtommath.a ${LDFLAGS}|' -i clit${TERMUX_PKG_VERSION/./}/Makefile
	# Use system CFLAGS
	sed -e 's|CFLAGS=-O3 -Wall|CFLAGS+=|' -i lib/Makefile
	sed -e 's|CFLAGS=-funsigned-char -Wall -O2|CFLAGS+=|' -i clit${TERMUX_PKG_VERSION/./}/Makefile
	sed -e 's|gcc -o|${CC} -o|' -i clit${TERMUX_PKG_VERSION/./}/Makefile
}

termux_step_make() {
	export CFLAGS+=" -Wno-implicit-function-declaration"
	make -C lib
	make -C clit${TERMUX_PKG_VERSION/./}
}

termux_step_make_install() {
	install -Dm755 "clit${TERMUX_PKG_VERSION/./}/clit" -t "$TERMUX_PREFIX/bin"
}
