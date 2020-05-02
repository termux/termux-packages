TERMUX_PKG_HOMEPAGE=https://github.com/cswl/tsu
TERMUX_PKG_DESCRIPTION="A su wrapper for Termux"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_VERSION=8.2.0
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SRCURL=(https://github.com/cswl/tsu/archive/v$TERMUX_PKG_VERSION.tar.gz)
TERMUX_PKG_SHA256=(583c5c2a9a2545ae35bddcb50e9759b468f6a37aed68b90029d005403d3f4e24)

termux_step_make() {
	python3 ./extract_usage.py
}

termux_step_make_install() {
	# There is no install.sh script in the repository for now
	mkdir -p "$TERMUX_PREFIX/bin"
	cp $TERMUX_PKG_SRCDIR/tsu "$TERMUX_PREFIX/bin/tsu"
	chmod 0755 "$TERMUX_PREFIX/bin/tsu"
	# sudo - is an included addon in tsu now
	ln -sf "$TERMUX_PREFIX/bin/tsu" "$TERMUX_PREFIX/bin/sudo"
}
