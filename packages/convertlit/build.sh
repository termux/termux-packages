# Dependency for ebook-tools
TERMUX_PKG_HOMEPAGE='http://www.convertlit.com/'
TERMUX_PKG_DESCRIPTION='An extractor/converter for .LIT eBooks'
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.8
TERMUX_PKG_SRCURL=http://www.convertlit.com/clit18src.zip
TERMUX_PKG_SHA256=d70a85f5b945104340d56f48ec17bcf544e3bb3c35b1b3d58d230be699e557ba
TERMUX_PKG_DEPENDS="libtommath-static"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_get_source() {
	mkdir -p $TERMUX_PKG_SRCDIR
	termux_download $TERMUX_PKG_SRCURL $TERMUX_PKG_SRCDIR/clit18src.zip $TERMUX_PKG_SHA256
	cd $TERMUX_PKG_SRCDIR
	unzip clit18src.zip
}

termux_step_configure() {
	# Link to correct libtommath and use system LDFLAGS
	sed -e 's|../libtommath-0.30/libtommath.a|'$TERMUX_PREFIX'/lib/libtommath.a ${LDFLAGS}|' -i clit18/Makefile
	# Use system CFLAGS
	sed -e 's|CFLAGS=-O3 -Wall|CFLAGS+=|' -i lib/Makefile
	sed -e 's|CFLAGS=-funsigned-char -Wall -O2|CFLAGS+=|' -i clit18/Makefile
	sed -e 's|gcc -o|${CC} -o|' -i clit18/Makefile
}

termux_step_make() {
	export CFLAGS+=" -Wno-implicit-function-declaration"
	cd lib && make
	cd ../clit18 && make
}

termux_step_make_install() {
	cd clit18
	install -Dm755 clit -t $TERMUX_PREFIX/bin
}
