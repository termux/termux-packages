TERMUX_PKG_HOMEPAGE=https://plocate.sesse.net/
TERMUX_PKG_DESCRIPTION="A much faster locate"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.25"
TERMUX_PKG_SRCURL="https://plocate.sesse.net/download/plocate-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=68c1d5fbb11864403ae39c1a5937f13afd80b03e68041368831ef58cb613578e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, zstd"
TERMUX_PKG_SUGGESTS="cronie"
TERMUX_PKG_BREAKS="mlocate"
TERMUX_PKG_PROVIDES="locate, mlocate"
TERMUX_PKG_REPLACES="mlocate"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dinstall_systemd=false
-Dsbindir=bin
-Dsharedstatedir=var/lib
"

termux_extract_src_archive() {
	local file="$TERMUX_PKG_CACHEDIR/${TERMUX_PKG_SRCURL##*/}"
	mkdir -p "$TERMUX_PKG_SRCDIR"
	tar xf "$file" -C "$TERMUX_PKG_SRCDIR"
}

termux_step_pre_configure() {
	CXXFLAGS+=" -Dprogram_invocation_name=getprogname()"
}

termux_step_post_make_install() {
	ln -sf plocate "$TERMUX_PREFIX/bin/locate"
}
