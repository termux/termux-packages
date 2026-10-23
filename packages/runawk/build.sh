TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/runawk
TERMUX_PKG_DESCRIPTION="Wrapper for AWK interpreter implementing a modules system"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="doc/LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.1
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/runawk/runawk/runawk-${TERMUX_PKG_VERSION}/runawk-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e767a3d152fc6101902545ec21cc057a3a97343d8fab7b6f02acaf72f9eeb731
TERMUX_PKG_DEPENDS="gawk"
TERMUX_PKG_AUTO_UPDATE=false # Built by hand from a fixed source file list instead of mk-configure
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	local modulesdir="$TERMUX_PREFIX/share/runawk"
	cd runawk
	$CC $CPPFLAGS $CFLAGS $LDFLAGS \
		-DAWK_PROG="\"$TERMUX_PREFIX/bin/awk\"" \
		-DSTDIN_FILENAME='"-"' \
		-DMODULESDIR="\"$modulesdir:$modulesdir/gawk\"" \
		-DRUNAWK_VERSION="\"$TERMUX_PKG_VERSION\"" \
		-DTEMPDIR="\"$TERMUX_PREFIX/tmp\"" \
		-o runawk runawk.c dynarray.c file_hier.c
}

termux_step_make_install() {
	install -Dm755 runawk/runawk "$TERMUX_PREFIX/bin/runawk"
	install -Dm755 -t "$TERMUX_PREFIX/bin" a_getopt/alt_getopt
	install -Dm644 -t "$TERMUX_PREFIX/bin" a_getopt/alt_getopt.sh
	install -Dm644 -t "$TERMUX_PREFIX/share/runawk" modules/*.awk
	install -Dm644 -t "$TERMUX_PREFIX/share/runawk/gawk" modules/gawk/*.awk
	install -Dm644 runawk/runawk.1 "$TERMUX_PREFIX/share/man/man1/runawk.1"
	install -Dm644 a_getopt/alt_getopt.1 "$TERMUX_PREFIX/share/man/man1/alt_getopt.1"
	install -Dm644 modules/runawk_modules.3 "$TERMUX_PREFIX/share/man/man3/runawk_modules.3"
}
