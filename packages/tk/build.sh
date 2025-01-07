TERMUX_PKG_HOMEPAGE=https://tcl.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A windowing toolkit for use with tcl"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="license.terms"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="8.6.14"
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/sourceforge/tcl/tk${TERMUX_PKG_VERSION}-src.tar.gz
TERMUX_PKG_SHA256=8ffdb720f47a6ca6107eac2dd877e30b0ef7fac14f3a84ebbd0b3612cee41a94
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="fontconfig, libx11, libxft, libxss, tcl"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_MAKE_INSTALL_TARGET="install install-private-headers"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--mandir=$TERMUX_PREFIX/share/man
--enable-threads
--enable-64bit
"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/unix"
}

termux_step_post_make_install() {
	ln -sfr "$TERMUX_PREFIX/bin/wish${TERMUX_PKG_VERSION:0:3}" \
		"$TERMUX_PREFIX"/bin/wish
	ln -sfr "$TERMUX_PREFIX/lib/libtk${TERMUX_PKG_VERSION:0:3}.so" \
		"$TERMUX_PREFIX"/lib/libtk.so

	cd "$TERMUX_PKG_SRCDIR"/../

	for dir in compat generic generic/ttk unix; do
		install -dm755 "$TERMUX_PREFIX/include/tk-private/$dir"
		install -m644 -t "$TERMUX_PREFIX/include/tk-private/$dir" "$dir"/*.h
	done
}
